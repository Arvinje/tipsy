require "tipsy/version"
require 'dotenv'
require 'celluloid/current'
require "redis-namespace"
require "redis"
require "mongoid"
require "foursquare2"
require 'logger'
require 'descriptive_statistics'
if defined? JRUBY_VERSION
  require "stanford-core-nlp"
  require 'nlplib/slf4j-api.jar'
  require 'nlplib/slf4j-simple.jar'
end
require "tipsy/models/venue"
require "tipsy/models/tip"
require "tipsy/models/unigram"
require "tipsy/models/bigram"
require "tipsy/models/trigram"
require "tipsy/fetch_venues"
require "tipsy/fetch_tips"
require "tipsy/tip_fetcher_worker"
require "tipsy/word_hash_builder"
require "tipsy/word_miner"
require "tipsy/preprocess_all"
require "tipsy/preprocessor"
require "tipsy/all_ngrams"
require "tipsy/extract_ngrams"
require "tipsy/extract_bigrams"
require "tipsy/tips_ratings"
require "tipsy/fetch_all"
require "tipsy/text_analyzer"
require "tipsy/evaluate_unigrams"
require "tipsy/evaluate_ngrams"
require "tipsy/mean_ngram_polarity"
require "tipsy/counting_ngram_polarity"
require "tipsy/webservice"
require "csv"

module Tipsy
  Mongoid.load!("mongoid.yml", :development)
  Dotenv.load

  if defined? JRUBY_VERSION
    StanfordCoreNLP.use :english
    StanfordCoreNLP.model_files = {}
    StanfordCoreNLP.default_jars = [
      'joda-time.jar',
      'xom.jar',
      'stanford-corenlp-3.6.0.jar',
      'stanford-english-corenlp-2016-01-10-models.jar',
      'jollyday.jar',
      'bridge.jar'
    ]
  end

  $redis = Redis::Namespace.new("tipsy", :redis => Redis.new)

  class << self
    attr_accessor :log
    def client
      @client ||= Foursquare2::Client.new(client_id: ENV['FOURSQUARE_CLIENT_ID'],
                              client_secret: ENV['FOURSQUARE_CLIENT_SECRET'],
                              api_version: '20160516')
    end

    def redis_to_csv
      CSV.open('redis_output.csv', 'w') do |csv_object|
        csv_object << ['key', 'score', 'repeat', 'average']
        $redis.keys.each do |key|
          hash = $redis.hgetall(key)
          csv_object << [key, hash['score'].to_f, hash['repeat'].to_i, hash['average'].to_f]
        end
      end

    end
  end

  Tipsy.log = Logger.new STDOUT
  Tipsy.log.level = Logger::DEBUG
  Tipsy.log.datetime_format = '%Y-%m-%d %H:%M:%S '

end
