# frozen_string_literal: true

#  Rake tasks to manage native gem packages with binary executables from charmbracelet/gum
#
#  TL;DR: run "rake package"
#
#  The native platform gems (defined by Gum::Upstream::NATIVE_PLATFORMS) will each contain
#  two files in addition to what the vanilla ruby gem contains:
#
#     exe/
#     ├── gum                               #  generic ruby script to find and run the binary
#     └── <Gem::Platform architecture name>/
#         └── gum                           #  the gum binary executable
#
#  The ruby script `exe/gum` is installed into the user's path, and it simply locates the
#  binary and executes it. Note that this script is required because rubygems requires that
#  executables declared in a gemspec must be Ruby scripts.
#
#  As a concrete example, an x86_64-linux system will see these files on disk after installing
#  gum-0.x.x-x86_64-linux.gem:
#
#     exe/
#     ├── gum
#     └── x86_64-linux/
#         └── gum
#
#  So the full set of gem files created will be:
#
#  - pkg/gum-0.1.0.gem
#  - pkg/gum-0.1.0-arm64-darwin.gem
#  - pkg/gum-0.1.0-arm64-linux.gem
#  - pkg/gum-0.1.0-aarch64-linux.gem
#  - pkg/gum-0.1.0-x86_64-darwin.gem
#  - pkg/gum-0.1.0-x86_64-linux.gem
#
#  Note that in addition to the native gems, a vanilla "ruby" gem will also be created without
#  either the `exe/gum` script or a binary executable present.
#
#
#  New rake tasks created:
#
#  - rake gem:ruby           # Build the ruby gem
#  - rake gem:arm64-darwin   # Build the arm64-darwin gem
#  - rake gem:arm64-linux    # Build the arm64-linux gem
#  - rake gem:aarch64-linux  # Build the aarch64-linux gem
#  - rake gem:x86_64-darwin  # Build the x86_64-darwin gem
#  - rake gem:x86_64-linux   # Build the x86_64-linux gem
#  - rake download           # Download all gum binaries
#
#  Modified rake tasks:
#
#  - rake gem                # Build all the gem files
#  - rake package            # Build all the gem files (same as `gem`)
#  - rake repackage          # Force a rebuild of all the gem files
#
#  Note also that the binary executables will be lazily downloaded when needed, but you can
#  explicitly download them with the `rake download` command.

require "rubygems/package"
require "rubygems/package_task"
require "net/http"
require "stringio"
require "zlib"

require_relative "../lib/gum/upstream"

def gum_download_url(filename)
  "https://github.com/charmbracelet/gum/releases/download/v#{Gum::Upstream::VERSION}/#{filename}"
end

def fetch_with_redirects(url, limit = 10)
  raise "Too many redirects" if limit.zero?

  uri = URI.parse(url)
  response = Net::HTTP.get_response(uri)

  case response
  when Net::HTTPSuccess
    response.body
  when Net::HTTPRedirection
    fetch_with_redirects(response["location"], limit - 1)
  else
    raise "Failed to download #{url}: #{response.code} #{response.message}"
  end
end

GUM_GEMSPEC = Bundler.load_gemspec("gum.gemspec")

gem_path = Gem::PackageTask.new(GUM_GEMSPEC).define
desc "Build the ruby gem"
task "gem:ruby" => [gem_path]

exepaths = []

Gum::Upstream::NATIVE_PLATFORMS.each do |platform, filename|
  GUM_GEMSPEC.dup.tap do |gemspec|
    exedir = File.join(gemspec.bindir, platform) # "exe/x86_64-linux"
    exepath = File.join(exedir, "gum") # "exe/x86_64-linux/gum"

    exepaths << exepath

    gemspec.platform = platform
    gemspec.files += [exepath]

    gem_path = Gem::PackageTask.new(gemspec).define
    desc "Build the #{platform} gem"
    task "gem:#{platform}" => [gem_path]

    directory exedir

    file exepath => [exedir] do
      release_url = gum_download_url(filename)
      warn "Downloading #{exepath} from #{release_url} ..."

      # The tarball structure is: gum_VERSION_OS_ARCH/gum
      # e.g., gum_0.17.0_Darwin_arm64/gum
      tarball_dir = filename.sub(".tar.gz", "")
      binary_path_in_tarball = "#{tarball_dir}/gum"

      tarball_data = fetch_with_redirects(release_url)

      Zlib::GzipReader.wrap(StringIO.new(tarball_data)) do |gz|
        Gem::Package::TarReader.new(gz) do |reader|
          reader.seek(binary_path_in_tarball) do |file|
            File.binwrite(exepath, file.read)
          end
        end
      end

      FileUtils.chmod(0o755, exepath, verbose: true)
    end
  end
end

desc "Download all binaries"
task "download" => exepaths
