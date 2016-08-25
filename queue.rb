require 'json'
require 'logger'

class Queue
  NAME = 'images'

  def self.add(client, urls)
    client.sadd(NAME, urls.to_json)
  end

  def self.add_error(client, urls)
    client.sadd("#{NAME}_error", urls.to_json)
  end

  def self.pop(client)
    urls = client.spop(NAME)
    r = urls ? urls : "[]"
  end
end
