# -*- encoding: utf-8 -*-
require 'twitter'
require 'clockwork'
require 'redis'
require 'heroku-api'

class TwitterBot
  include Clockwork

  attr_reader :redis
  def initialize
    uri = URI.parse(REDIS_URI)
    @redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

    @client = Twitter::Client.new(
      :consumer_key => CONSUMER_KEY,
      :consumer_secret => CONSUMER_SECRET,
      :oauth_token => ACCESS_TOKEN,
      :oauth_token_secret => ACCESS_TOKEN_SECRET
    )
    @timeline = []
    @timeline_since = 1
    @reply = []
    @reply_since = 1
  end

  def require_plugin(name)
    require "#{PLUGIN_ROOT}/#{name}"
    self.extend name.classify.constantize
  end

  def job(param = {})
    return unless param[:intval] && param[:func]

    every(param[:intval], param[:func].to_s) do
      self.send(param[:func])
    end
  end

  def hello
    puts "hello"
  end

  def get_timeline
    @timeline = @client.home_timeline :count => 200, :since_id => @timeline_since
    dump_statuses(@timeline)
  end

  def get_reply
    @reply = @client.mentions_timeline :count => 200, :since_id => @reply_since
    dump_statuses(@reply)
  end

  def dump_statuses(statuses)
    statuses.each do |status|
      puts "--------------------------------"
      puts "@#{status['user']['screen_name']}(#{status['user']['name']}) at #{status['created_at']}"
      puts "#{status['text']}"
    end
  end

  def update(msg)
    if ((defined? DEBUG) && DEBUG)
      puts msg
    else
      @client.update(msg)
    end
  end

  def deploy_time
    time = redis.get('deploy_time').to_i
    time = 1 if time <= 0
    return time
  end

  def deploy_time=(time)
    redis.set('deploy_time', time)
  end
end
