# -*- encoding: utf-8 -*-
require 'twitter'
require 'clockwork'
require "#{CONFIG_ROOT}/account_config"

class TwitterBot
  include Clockwork

  def initialize
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

    job :intval => 3.seconds, :func => :hello

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

  def update_timeline
    @timeline = @client.home_timeline :count => 200, :since_id => @timeline_since
    dump_statuses(@timeline)
  end

  def update_reply
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
    if defined? DEBUG && DEBUG
      puts msg
    else
      @client.update(msg)
    end
  end
end
