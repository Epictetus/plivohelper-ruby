require 'rubygems'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.name = "plivohelper"
  s.version = "0.1"
  s.author = "Team Plivo"
  s.email = "hello@plivo.org"
  s.homepage = "http://www.plivo.org/documentation"
  s.description = "A Ruby gem for communicating with the Plivo API and generating RESTXML"
  s.platform = Gem::Platform::RUBY
  s.summary = "A Ruby gem for communicating with the Plivo API and generating RESTXML"
  s.files = FileList["{lib}/*"].to_a
  s.require_path = "lib"
  s.test_files = FileList["{test}/response_spec.rb"].to_a
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rst"]
  s.add_dependency("builder", ">= 2.1.2")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
    puts "generated latest version"
end
