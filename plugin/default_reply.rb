# -*- encoding: utf-8 -*-
module DefaultReply
  def default_reply
    update [
      'と思うじゃん？',
      '今日はいい天気ですね',
      'おなかすいた',
    ].sample
  end
end
