$:.push File.expand_path("../lib", __FILE__)
require "jruby_mahout/version"

Gem::Specification.new do |gem|
  gem.name        = "jruby_mahout"
  gem.version     = JrubyMahout::VERSION
  gem.authors     = ["Vasily Vasinov"]
  gem.email       = ["vasinov@me.com"]
  gem.homepage    = "https://github.com/vasinov/jruby_mahout"
  gem.summary     = "JRuby Mahout is a gem that unleashes the power of Apache Mahout in the world of JRuby."
  gem.description = "JRuby Mahout is a gem that unleashes the power of Apache Mahout in the world of JRuby. Mahout is a superior machine learning library written in Java. It deals with recommendations, clustering and classification machine learning problems at scale. Until now it was difficult to use it in Ruby projects. You'd have to implement Java interfaces in Jruby yourself, which is not quick especially if you just started exploring the world of machine learning."
  gem.license = "MIT"

  gem.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  gem.test_files = Dir["spec/**/*"]
  gem.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }

  gem.add_dependency "redis", "~> 3.0"

  gem.add_development_dependency "rake", "~>10.3"
  gem.add_development_dependency "ruby-debug"
  gem.add_development_dependency "rspec"
end
