require 'json'
require 'logger'

class Queue
  NAME = 'images'

  def self.add(client, urls)
    client.sadd(NAME, urls.to_json)
  end

  def self.pop(client)
    urls = client.spop(NAME)
    urls ? urls : "[]"
  end

  private

  def self.size(client)
    client.scard(NAME)
  end
end
