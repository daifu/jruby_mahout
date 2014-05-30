module JrubyMahout
  require 'java'
  Dir.glob("#{ENV['MAHOUT_DIR']}/libexec/*.jar").each { |d| require d }

  require 'jruby_mahout/recommender'
  require 'jruby_mahout/recommender_builder'
  require 'jruby_mahout/data_model'
  require 'jruby_mahout/evaluator'
  require 'jruby_mahout/postgres_manager'
  require 'jruby_mahout/mysql_manager'
end