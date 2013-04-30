# -*- encoding: utf-8 -*-
require 'rubygems'
require 'active_support/all'

BOT_ROOT = File.expand_path('../', __FILE__)

require "#{BOT_ROOT}/config/environment"
require "#{BOT_ROOT}/#{BOT_NAME}"

@bot = BOT_NAME.classify.constantize.new

