# -*- encoding: utf-8 -*-
require 'twitter'
require File.expand_path('../config/account_config', __FILE__);

class TwitterBot
  def initialize
    @client = Twitter::Client.new(
      :consumer_key => CONSUMER_KEY,
      :consumer_secret => CONSUMER_SECRET,
      :oauth_token => ACCESS_TOKEN,
      :oauth_token_secret => ACCESS_TOKEN_SECRET
    )
  end

  def update(msg)
    @client.update(msg)
  end
end

