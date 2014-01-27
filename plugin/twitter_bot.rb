# -*- encoding: utf-8 -*-
require 'twitter'
require 'userstream'
require 'clockwork'
require 'redis'
require 'heroku-api'

class TwitterBot
  include Clockwork

  attr_reader :redis
  def initialize
    uri = URI.parse(REDIS_URI)
    @redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

    @client = Twitter::REST::Client.new(
      :consumer_key => CONSUMER_KEY,
      :consumer_secret => CONSUMER_SECRET,
      :oauth_token => ACCESS_TOKEN,
      :oauth_token_secret => ACCESS_TOKEN_SECRET
    )
    @timeline = []
    @timeline_since = 1
    @reply = []
    @reply_since = 1
    init_stream
    user_stream
  end

  def require_plugin(name)
    require "#{PLUGIN_ROOT}/#{name}"
    self.extend name.classify.constantize
  end

  def job(param = {})
    return unless param[:intval] && param[:func]

    every(param[:intval], param[:func].to_s, :at => param[:at] ? param[:at].to_s : nil) do
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

  private
  def init_stream
    UserStream.configure do |config|
      config.consumer_key = CONSUMER_KEY
      config.consumer_secret = CONSUMER_SECRET
      config.oauth_token = ACCESS_TOKEN
      config.oauth_token_secret = ACCESS_TOKEN_SECRET
    end
  end

  private
  def user_stream
    thread = Thread .new do
      crash_count = 0
      loop do
        puts 'start user stream'
        t = Thread.new do
          @user_stream = UserStream.client
          @user_stream.user do |status|
            before_on_status status
          end
        end

        begin
          t.join
        rescue => e
          crash_count += 1
          puts e.class
          puts e.message
          puts e.backtrace
          puts "[UserStream] ERROR retry... (#{crash_count} times)"
        end
        sleep 5
      end
    end
    # thread.join
  end

  private
  def before_on_status(status)
    @redis.lpush('twitter:status_id', status.id) if status.text
    @redis.hmset("twitter:status:#{status.id}",
                 'user_name', status.user.name,
                   'user_id', status.user.id,
                   'screen_name', status.user.screen_name,
                   'text', status.text,
                   'in_reply_to_status_id', status.in_reply_to_status_id,
                   'created_at', status.created_at
                ) if status.text
    @redis.lpush('twitter:delete_id', status[:delete].status.id) if status[:delete]
    if reply? status
      on_reply_status status
    else
      on_status status
    end
  end

  private
  def reply?(status)
    status && 
      status.in_reply_to_screen_name.kind_of?(String) &&
      (status.in_reply_to_screen_name.downcase == MY_ID.downcase)
  end

  def on_status(status)
    # on status hook
  end

  def on_reply_status(status)
    # on status hook
  end

  def dump_statuses(statuses)
    statuses.each do |status|
      dump_status status
    end
  end

  def dump_status(status)
    puts "--------------------------------"
    puts "@#{status['user']['screen_name']}(#{status['user']['name']}) at #{status['created_at']}"
    puts "#{status['text']}"
  end

  def update(msg, options = {})
    (defined? DEBUG) && DEBUG ?  puts(msg) : @client.update(msg, options)
    return msg
  end

  def favorite(status)
    return unless status.text
    (defined? DEBUG) && DEBUG ?  puts('favorite: ' + status.text) : @client.favorite(status.id)
  end

  def deploy_time
    time = redis.get('twitter:deploy_time').to_i
    time = 1 if time <= 0
    return time
  end

  def deploy_time=(time)
    redis.set('twitter:deploy_time', time)
  end
end
