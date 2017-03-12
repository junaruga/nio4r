# frozen_string_literal: true

ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
LIVEV = {
  name: "libev",
  version: "4.23",
  sha256: "c7fe743e0c3b50dd34bf222ebdba4e8acac031d41ce174f17890f8f84eeddd7a",
}

if defined? JRUBY_VERSION
  require "rake/javaextensiontask"
  Rake::JavaExtensionTask.new("nio4r_ext") do |ext|
    ext.ext_dir = "ext/nio4r"
  end
else
  #task :compile => [:libev] do
  #  # patch to libev
  #end

  require "rake/extensiontask"
  Rake::ExtensionTask.new("nio4r_ext") do |ext|
    ext.ext_dir = "ext/nio4r"
  end
end

class MiniPortile
  # See https://github.com/flavorjones/mini_portile/blob/v2.1.0/
  def apply_patch(patch_file)
    (
      lambda { |file|
        message "Running patch with #{file}... "
        execute('patch', ["patch", "-p1", "-i", file],
          :initial_message => false)
      }
    ).call(patch_file)
  end
end

desc "Download and extract libev"
task :libev do
  require "mini_portile2"
  recipe = MiniPortile.new(LIVEV[:name], LIVEV[:version])
  url = "http://dist.schmorp.de/libev/Attic/%s-%s.tar.gz" %
    [recipe.name, recipe.version]
  recipe.files << {
    url: url,
    sha256: LIVEV[:sha256]
  }
  recipe.patch_files =
    Dir[File.join(ROOT, "patches", recipe.name, "*.patch")].sort

  #patch_file = File.join(ROOT, "patches", LIVEV[:name], "nio4r.patch")

  recipe.download
  recipe.extract
  recipe.patch
  #`cat #{patch_file} | patch -p1 -F 0`
  #unless $?.to_i
  #  throw RuntimeError("Failed patch: #{patch_cmd}")
  #end

  # recipe.activate
end
