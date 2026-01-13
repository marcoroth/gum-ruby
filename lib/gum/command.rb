# frozen_string_literal: true
# typed: true
# rbs_inline: enabled

require "English"
require "open3"

module Gum
  module Command
    def self.run(*, input: nil, interactive: true)
      if !interactive
        run_non_interactive(*, input: input)
      elsif input
        run_interactive_with_input(*, input: input)
      else
        run_interactive(*)
      end
    end

    def self.run_non_interactive(*args, input:)
      stdout, stderr, status = Open3.capture3(Gum.executable, *args.map(&:to_s), stdin_data: input)

      unless status.success?
        return nil if status.exitstatus == 130 # User cancelled (Ctrl+C)

        raise Error, "gum #{args.first} failed: #{stderr}" unless stderr.empty?
      end

      stdout.chomp
    end

    def self.run_interactive(*args)
      tty = File.open("/dev/tty", "r+")

      stdout, wait_thread = Open3.pipeline_r(
        [Gum.executable, *args.map(&:to_s)],
        in: tty,
        err: tty
      )

      output = stdout.read.chomp
      stdout.close
      tty.close

      status = wait_thread.last.value
      return nil if status.exitstatus == 130 # User cancelled
      return nil unless status.success?

      output
    rescue Errno::ENOENT, Errno::ENXIO, Errno::EIO
      stdout, stderr, status = Open3.capture3(Gum.executable, *args.map(&:to_s))

      unless status.success?
        return nil if status.exitstatus == 130
        raise Error, "gum #{args.first} failed: #{stderr}" unless stderr.empty?
      end

      stdout.chomp
    end

    def self.run_interactive_with_input(*args, input:)
      tty = File.open("/dev/tty", "r+")
      stdin_read, stdin_write = IO.pipe
      stdout_read, stdout_write = IO.pipe

      pid = Process.spawn(
        Gum.executable, *args.map(&:to_s),
        in: stdin_read,
        out: stdout_write,
        err: tty
      )

      stdin_read.close
      stdout_write.close

      stdin_write.write(input)
      stdin_write.close

      output = stdout_read.read.chomp
      stdout_read.close

      _, status = Process.wait2(pid)
      tty.close

      return nil if status.exitstatus == 130 # User cancelled
      return nil unless status.success?

      output
    rescue Errno::ENOENT, Errno::ENXIO, Errno::EIO
      run_non_interactive(*args, input: input)
    end

    def self.run_display_only(*args, input:)
      IO.popen([Gum.executable, *args.map(&:to_s)], "w") do |io|
        io.write(input)
      end

      $CHILD_STATUS.success? || nil
    rescue Errno::ENOENT
      raise Error, "gum executable not found"
    end

    def self.run_with_status(*args, input: nil)
      if input
        _stdout, _stderr, status = Open3.capture3(Gum.executable, *args.map(&:to_s), stdin_data: input)
        status.success?
      else
        system(Gum.executable, *args.map(&:to_s))
      end
    end

    def self.build_args(command, *positional, **options)
      args = [command]
      args.concat(positional.flatten.compact)

      options.each do |key, value|
        next if value.nil?

        flag = key.to_s.tr("_", "-")

        case value
        when true
          args << "--#{flag}"
        when false
          args << "--no-#{flag}" if flag_supports_negation?(command, flag)
        when Array
          value.each { |v| args << "--#{flag}=#{v}" }
        when Hash
          value.each { |k, v| args << "--#{flag}.#{k}=#{v}" }
        else
          args << "--#{flag}=#{value}"
        end
      end

      args
    end

    def self.add_style_args(args, flag, style_hash)
      return unless style_hash

      style_hash.each do |key, value|
        args << "--#{flag}.#{key}" << value.to_s
      end
    end

    def self.flag_supports_negation?(command, flag)
      negatable = {
        "filter" => ["fuzzy", "sort", "strict", "reverse", "indicator"],
        "choose" => ["limit"],
        "input" => ["echo-mode"],
        "file" => ["all", "file", "directory"],
        "pager" => ["soft-wrap"],
        "table" => ["border", "print"],
      }

      negatable.fetch(command, []).include?(flag)
    end
  end
end
