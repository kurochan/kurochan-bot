# -*- encoding: utf-8 -*-

require 'rubygems'
require 'twitter'

require File.expand_path('../config/account_config', __FILE__);

Twitter.configure do |config|
  config.consumer_key       = CONSUMER_KEY
  config.consumer_secret    = CONSUMER_SECRET
  config.oauth_token        = ACCESS_TOKEN
  config.oauth_token_secret = ACCESS_TOKEN_SECRET
end

Twitter.update('Hello World!')

