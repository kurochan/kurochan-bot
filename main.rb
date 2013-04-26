# -*- encoding: utf-8 -*-
require 'rubygems'
require 'active_support/all'

require File.expand_path('../config/environment', __FILE__);
require File.expand_path("../#{BOT_NAME}", __FILE__);

bot = BOT_NAME.classify.constantize.new

