# -*- encoding: utf-8 -*-
require 'rubygems'
require 'active_support/all'

BOT_ROOT = File.expand_path('../', __FILE__)
PLUGIN_ROOT = "#{BOT_ROOT}/plugin"
CONFIG_ROOT = "#{BOT_ROOT}/config"

require "#{CONFIG_ROOT}/config"
require "#{PLUGIN_ROOT}/twitter_bot"
require "#{BOT_ROOT}/#{BOT_NAME}"

@bot = BOT_NAME.classify.constantize.new
