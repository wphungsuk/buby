require 'rubygems'
require 'rake'
require 'rake/clean'

CLEAN.add 'tmp'
CLOBBER.add '**/*.class', '**/buby.jar', "doc", '.yardoc'

begin
  require 'jeweler'
  jeweler = Jeweler::Tasks.new do |gem|
    gem.name = "buby"
    gem.summary = %q{Buby is a mashup of JRuby with the popular commercial web security testing tool Burp Suite from PortSwigger}
    gem.description = %q{Buby is a mashup of JRuby with the popular commercial web security testing tool Burp Suite from PortSwigger.  Burp is driven from and tied to JRuby with a Java extension using the BurpExtender API.  This extension aims to add Ruby scriptability to Burp Suite with an interface comparable to the Burp's pure Java extension interface.}
    gem.email = "td@matasano.com"
    gem.homepage = "http://tduehr.github.com/buby"
    gem.authors = ["Eric Monti, tduehr"]
    gem.platform = "java"
    gem.files.include "**/buby.jar"
    gem.files.include "**/burp_interfaces.jar"
    gem.test_files = ["test/buby_test.rb"]
    gem.rdoc_options = ["--main", "README.rdoc"]
    gem.extra_rdoc_files = ["History.txt", "README.rdoc", "bin/buby"]
    gem.add_development_dependency "rake-compiler", "~> 0.8.1"
  end.jeweler
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test' << 'java'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :test => :check_dependencies

task :default => :test

begin
  require 'rdoc/task'
  Rake::RDocTask.new do |rdoc|
    if File.exist?('VERSION')
      version = File.read('VERSION')
    else
      version = ""
    end

    rdoc.rdoc_dir = 'rdoc'
    rdoc.title = "buby #{version}"
    rdoc.rdoc_files.include('README*')
    rdoc.rdoc_files.include('History.txt')
    rdoc.rdoc_files.include('bin/buby')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
rescue LoadError
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new
  YARD::Rake::YardocTask.new(:todo) do |yard|
    yard.options.concat ['--query', '@todo']
    yard.options << "--list"
  end
rescue LoadError
end

begin
  require 'rake/javaextensiontask'
  Rake::JavaExtensionTask.new('burp_interfaces', jeweler.gemspec)
  Rake::JavaExtensionTask.new('buby', jeweler.gemspec) do |jet|
    jet.classpath = "lib/burp_interfaces.jar"
  end
  task :test => :compile
  task :build => :compile
rescue LoadError
  warn 'rake-compiler not found. java compilation must be performed manually'
end

namespace :version do
  task :nice do
    version_hash = YAML.load_file 'VERSION.yml'
    version_string = ""
    version_string << version_hash[:major].to_s
    version_string << ".#{version_hash[:minor].to_s}"
    version_string << ".#{version_hash[:patch].to_s}"
    version_string << ".#{version_hash[:build].to_s}" if version_hash[:build]
    File.open('lib/buby/version.rb', 'w') do |file|
      file.write <<EOS
class Buby
  module Version
    STRING = "#{version_string}"
    MAJOR = #{version_hash[:major].to_i}
    MINOR = #{version_hash[:minor].to_i}
    PATCH = #{version_hash[:patch].to_i}
    BUILD = #{version_hash[:build].inspect}
  end
end
EOS
    end
    jeweler.repo.add 'lib/buby/version.rb'
    jeweler.repo.commit "fixup! Version bump to #{version_string}"
    puts "Buby::Version updated to #{version_string}"
  end

  namespace :bump do
    task :patch do
      Rake::Task["version:nice"].invoke
    end
    task :patch do
      Rake::Task["version:nice"].invoke
    end
    task :patch do
      Rake::Task["version:nice"].invoke
    end
  end
end

desc "Start Buby in interactive mode with all runtime dependencies loaded"
task :test_console, [:script] do |t,args|
  # TODO move to a command
  dirs = ['ext', 'lib'].select { |dir| File.directory?(dir) }

  original_load_path = $LOAD_PATH

  cmd = if File.exist?('Gemfile')
          require 'bundler'
          Bundler.setup(:default)
        end

  # add the project code directories
  $LOAD_PATH.unshift(*dirs)

  # clear ARGV so IRB is not confused
  ARGV.clear

  require 'irb'

  require File.basename Dir.glob('lib/burpsuite_pro_*.jar').last
  require 'burp_interfaces.jar'
  require 'buby.jar'
  require 'buby'
  $burp = Buby.start_burp

  # set the optional script to run
  IRB.conf[:SCRIPT] = args.script
  IRB.start

  # return the $LOAD_PATH to it's original state
  $LOAD_PATH.reject! { |path| !(original_load_path.include?(path)) }
end
