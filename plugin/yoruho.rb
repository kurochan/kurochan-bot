# -*- encoding: utf-8 -*-
module Yoruho
  def yoruho
    # 卒業までの日数
    yday = Time.mktime(2014, 12, 31).yday - Time.new.yday + Time.mktime(2015, 3, 26).yday
    data = [
      "よるほー♪ 卒業まであと#{yday}日だよ！",
      "卒業まであと#{yday}日だよ！進捗どうですか！",
    ]
    update data[rand data.length]
  end
end
