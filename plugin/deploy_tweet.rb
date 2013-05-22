require 'heroku-api'
module DeployTweet
  def deploy_tweet
    update "revision #{revision} deployed!" unless revision == deploy_time
    self.deploy_time = revision
  end

  def revision
    api = Heroku::API.new(:api_key => HEROKU_API_KEY)
    releases = api.get_releases 'kurochan-bot'
    releases.data[:body][-1]['name'][-1, 1].to_i
  end
end
