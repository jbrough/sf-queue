require 'json'
require 'logger'

class Queue
  PENDING = 'images'
  ERRORS = 'images_err'

  def self.stats(client)
    { pending: client.scard(PENDING),
      errors: client.scard(ERRORS) }
  end

  def self.add(client, urls)
    client.sadd(PENDING, urls.to_json)
  end

  def self.add_error(client, urls)
    client.sadd(ERRORS, urls.to_json)
  end

  def self.pop(client)
    urls = client.spop(PENDING)
    r = urls ? urls : "[]"
  end
end
