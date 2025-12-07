# frozen_string_literal: true
# typed: true
# rbs_inline: enabled

module Gum
  # Log messages with different levels and formatting
  #
  # @example Basic logging
  #   Gum.log("Application started", level: :info)
  #
  # @example Structured logging with key-value pairs
  #   Gum.log("User created", level: :info, user_id: 123, email: "user@example.com")
  #
  # @example With timestamp
  #   Gum.log("Error occurred", level: :error, time: :rfc822)
  #
  class Log
    LEVELS = [:debug, :info, :warn, :error, :fatal, :none].freeze #: Array[Symbol]

    TIME_FORMATS = [
      :ansic, :unixdate, :rubydate, :rfc822, :rfc822z, :rfc850, :rfc1123, :rfc1123z, :rfc3339, :rfc3339nano, :kitchen
    ].freeze #: Array[Symbol]

    # Log a message
    #
    # @rbs message: String -- log message text
    # @rbs level: Symbol | String | nil -- log level (:debug, :info, :warn, :error, :fatal, :none)
    # @rbs time: Symbol | String | nil -- time format (:rfc822, :rfc3339, :kitchen, etc.) or custom Go time format
    # @rbs structured: bool? -- output structured log format (key=value pairs)
    # @rbs formatter: Symbol | String | nil -- log formatter (:text, :json, :logfmt)
    # @rbs prefix: String? -- log message prefix
    # @rbs **fields: untyped -- additional key-value fields for structured logging
    # @rbs return: String? -- formatted log output
    def self.call(
      message,
      level: nil,
      time: nil,
      structured: nil,
      formatter: nil,
      prefix: nil,
      **fields
    )
      options = {
        level: level&.to_s,
        time: time&.to_s,
        structured: structured,
        formatter: formatter&.to_s,
        prefix: prefix,
      }

      args = Command.build_args("log", **options.compact)

      args << message

      fields.each do |key, value|
        args << key.to_s
        args << value.to_s
      end

      Command.run(*args, interactive: false)
    end

    # @rbs message: String -- log message text
    # @rbs **fields: untyped -- additional key-value fields
    # @rbs return: String? -- formatted debug log output
    def self.debug(message, **fields)
      call(message, level: :debug, **fields)
    end

    # @rbs message: String -- log message text
    # @rbs **fields: untyped -- additional key-value fields
    # @rbs return: String? -- formatted info log output
    def self.info(message, **fields)
      call(message, level: :info, **fields)
    end

    # @rbs message: String -- log message text
    # @rbs **fields: untyped -- additional key-value fields
    # @rbs return: String? -- formatted warn log output
    def self.warn(message, **fields)
      call(message, level: :warn, **fields)
    end

    # @rbs message: String -- log message text
    # @rbs **fields: untyped -- additional key-value fields
    # @rbs return: String? -- formatted error log output
    def self.error(message, **fields)
      call(message, level: :error, **fields)
    end

    # @rbs message: String -- log message text
    # @rbs **fields: untyped -- additional key-value fields
    # @rbs return: String? -- formatted fatal log output
    def self.fatal(message, **fields)
      call(message, level: :fatal, **fields)
    end
  end
end
