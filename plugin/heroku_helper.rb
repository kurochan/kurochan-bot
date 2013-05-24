# -*- encoding: utf-8 -*-
module HerokuHelper
  def heroku_revision
    begin
      heroku_releases.data[:body][-1]['name'].delete('v').to_i
    rescue
      puts 'ERROR Cannot access heroku.'
    end
  end

  def heroku_releases
    return nil if (!(defined? HEROKU_API_KEY) ||
                   HEROKU_API_KEY == '' || !HEROKU_API_KEY)
    api = Heroku::API.new(:api_key => HEROKU_API_KEY)
    api.get_releases(HEROKU_REPO_NAME)
  end
end
