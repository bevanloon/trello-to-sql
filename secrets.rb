module Secrets
  def key
    ENV["TRELLO_KEY"]
  end

  def token
    ENV["TRELLO_TOKEN"]
  end
end
