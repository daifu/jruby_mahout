# JRuby Mahout

[![Code Climate](https://codeclimate.com/github/daifu/jruby_mahout.png)](https://codeclimate.com/github/daifu/jruby_mahout)

Jruby Mahout is a gem that unleashes the power of Apache Mahout in the world of JRuby. Mahout is a superior machine learning library written in Java. It deals with recommendations, clustering and classification machine learning problems at scale. Until now it was difficult to use it in Ruby projects. You'd have to implement Java interfaces in JRuby yourself, which is not quick especially if you just started exploring the world of machine learning.

The goal of this library is to make machine learning at scale in JRuby projects simple.

## Quick Overview
This is an early version of a JRuby gem that only supports Mahout recommendations. It also includes a simple Postgres manager that can be used to manage appropriate recommendations tables. Unfortunately it's impossible to use ActiveRecord (AR) with Mahout, because AR operates at a much higher level and creates a lot of overhead that is critical when dealing with millions of records in real time.

## Get Mahout
First of all you need to download the Mahout library from one of the [mirrors](http://www.apache.org/dyn/closer.cgi/mahout/). Jruby Mahout only supports Mahout 0.9 at this point.

## Get Postgres JDBC Adapter
If you wish to work with a database for recommendations, you'll have to install the [JDBC driver for Postgres](http://jdbc.postgresql.org/download.html). Another option is to use file-based recommendations.

## Get Mysql Connector/J
If you want to work with Mysql database for recommendations, you need to download [Mysql Connector/J](http://dev.mysql.com/downloads/connector/j/).

## Installation
### 1. Set the environment variable MAHOUT_DIR to point at your Mahout installation.
### 2. Add the gem to your `Gemfile`
```ruby
platform :jruby do
  gem "jruby_mahout", :git => git@github.com:daifu/jruby_mahout.git
end
```
### 3. Run `bundle install`.

## Brief Introduction
This is a fork of [vasinov](https://github.com/vasinov/jruby_mahout) and because vasinov havn't suported the project for a long time, then I try to matian this project during my free time.

I am planning to add more examples covering Jruby Mahout use cases soon.

First, define the `MAHOUT_DIR` environmental variable for your Mahout installation. For example:

```
export MAHOUT_DIR=/bin/mahout
```

The easiest way to start working with Jruby Mahout recommendations is to initialize a recommender:
```ruby
require 'jruby_mahout'
params      = {:similarity => "PearsonCorrelationSimilarity", :recommender => "GenericUserBasedRecommender", :neighborhood_size => 5}
recommender = JrubyMahout::Recommender.new(params)
```

Set up a data model:
```ruby
recommender.data_model = JrubyMahout::DataModel.new("file", { :file_path => "recommender_data.csv" }).data_model
```

and get recommendations:
```ruby
puts recommender.recommend(2, 10, nil) # 10 recommendations for user with id = 2
```

You can evaluate your recommender to see how efficient it is:
```ruby
puts recommender.evaluate(0.7, 0.3)
```

If you want to use redis to cache the result, you can change the params as following, by default the cache has no expiration:
```ruby
params = {:similarity => "PearsonCorrelationSimilarity", :recommender => "GenericUserBasedRecommender", :neighborhood_size => 5, :redis => {:url => 'redis://localhost:6379'}}
recommender = JrubyMahout::Recommender.new(params)
recommender.data_model = JrubyMahout::DataModel.new("file", { :file_path => "recommender_data.csv" }).data_model
recommender.recommend(2, 10, nil, {:expire_in => 3600}) # expire the cache in 3600 seconds
```

If you want to use rescorer, you can see this example:
``` ruby
params = {:similarity => "PearsonCorrelationSimilarity", :recommender => "GenericUserBasedRecommender", :neighborhood_size => 5, :redis => {:url => 'redis://localhost:6379'}}
recommender = JrubyMahout::Recommender.new(params)
recommender.data_model = JrubyMahout::DataModel.new("file", { :file_path => "recommender_data.csv" }).data_model

is_filtered = lambda { |id| id == 12 } # item id with 12 is out of stock
re_score    = lambda do |id, original_score|
  # item id with 9 is so popular recently, you want to boost the score manually
  id == 9 ? original_score + 1 : original_score
end
rescorer = JrubyMahout::CustomRescorer.new(is_filtered, re_score)
recommender.recommend(3,2,rescorer) # it will return without item with id 12 and item with id 9 will have an extra point
```

The closer the score is to zero—the better.

## Advanced
vasinov has an article on how to utilize JRuby Mahout in the real world projects. This is the first one in the series:
- [Machine Learning with Ruby, Part One](http://www.vasinov.com/blog/machine-learning-with-ruby-part-one)

## Development Plans
There are several things that should be supported by this gem, before it can be used in production. Some of them are:
- Spark integration
- Hadoop integration
- Clustering support
- Classification support
- Better docs

If you feel like you can help—please do.

## Testing
Jruby Mahout is thoroughly tested with Rspec.

```ruby
rspec spec/ # run all the test.
```

## FAQ
1. How to remove all the log message?
Because by default, there are some loging library from mahout, if you dont want those INFO message, you can download the package from [slf4j](http://www.slf4j.org/download.html), and copy slf4j-nop-1.7.7.jar to $MAHOUT_DIR/lib/ and remove slf4j-log4j12-1.7.5.jar from $MAHOUT_DIR/lib/

## Contribute
- Fork the project.
- Write code for a feature or bug fix.
- Add Rspec tests for it.
- Commit, do not make changes to rakefile or version.
- Submit a pull request.
