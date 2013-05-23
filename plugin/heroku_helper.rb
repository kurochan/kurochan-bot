# -*- encoding: utf-8 -*-
module HerokuHelper
  def heroku_revision
    return 0 if (!(defined? HEROKU_API_KEY) || HEROKU_API_KEY == '' || !HEROKU_API_KEY)
    begin
      api = Heroku::API.new(:api_key => HEROKU_API_KEY)
      releases = api.get_releases HEROKU_REPO_NAME
      releases.data[:body][-1]['name'].delete('v').to_i
    rescue
      puts 'ERROR Cannot access heroku.'
      return 0
    end
  end
end
