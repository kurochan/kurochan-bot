# -*- encoding: utf-8 -*-
module HerokuHelper
  def heroku_revision
    return 0 if (!(defined? HEROKU_API_KEY) || HEROKU_API_KEY == '' || !HEROKU_API_KEY)
    release = 0
    begin
      api = Heroku::API.new(:api_key => HEROKU_API_KEY)
      release = api.get_releases(HEROKU_REPO_NAME).
        data[:body][-1]['name'].delete('v').to_i
    rescue
      puts 'ERROR Cannot access heroku.'
    end
    return release
  end
end
