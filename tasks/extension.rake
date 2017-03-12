# frozen_string_literal: true

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

LIVEV = {
  name: "libev",
  version: "4.23",
  sha256: "c7fe743e0c3b50dd34bf222ebdba4e8acac031d41ce174f17890f8f84eeddd7a",
}

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
  checkpoint = ".#{recipe.name}-#{recipe.version}.installed"

  unless File.exist?(checkpoint)
    recipe.download
    recipe.extract
    touch checkpoint
  end

  # recipe.activate

  # recipe.patch_files = Dir[File.join(ROOT, "patches", name, "*.patch")].sort
end
