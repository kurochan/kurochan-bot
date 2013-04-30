# -*- encoding: utf-8 -*-
require 'twitter'
require 'clockwork'
require File.expand_path('../config/account_config', __FILE__);

class TwitterBot
  include Clockwork

  def initialize
    @client = Twitter::Client.new(
      :consumer_key => CONSUMER_KEY,
      :consumer_secret => CONSUMER_SECRET,
      :oauth_token => ACCESS_TOKEN,
      :oauth_token_secret => ACCESS_TOKEN_SECRET
    )
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

  def update(msg)
    @client.update(msg)
  end
end

