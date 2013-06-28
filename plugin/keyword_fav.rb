# -*- encoding: utf-8 -*-
module KeywordFav
  def keyword_fav(status)
    return unless status.text
    data = [
      'くろちゃん',
      '#先輩いない',
    ]
    data.each do |str|
      puts str.include? status.text
      if str.include? status.text
        favorite status
        break
      end
    end
  end
end
