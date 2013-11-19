# -*- encoding: utf-8 -*-
require 'uri'
require 'json'
require 'openssl'
require 'net/http'

module Reply
  def default_reply(status)
    puts "!#{status.text}"
    status.text = status.text.gsub(/@[A-z0-9_]+/, '').strip
    update "@#{status.user.screen_name} #{docomo_dialogue(status.text)}"
  end

  def docomo_dialogue(str)
    uri = URI.parse("https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue?APIKEY=#{DOCOMO_API_KEY}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type' =>'application/json'})
    request.body = {utt: str}.to_json
    response = nil
    http.start do |h|
      resp = h.request(request)
      response = JSON.parse(resp.body)
    end
    response['utt']
  end
end
