require 'json'
require 'logger'

class Queue
  NAME = 'images'

  def self.add(client, urls)
    begin
      client.sadd(NAME, urls.to_json)
    rescue => e
      Logger.new(STDERR).error(e)
      return e
    end

    return nil
  end

  def self.pop(client)
    begin
      urls = client.spop(NAME)
    rescue => e
      Logger.new(STDERR).error(e)
      return nil, e
    end

    r = urls ? urls : "[]"
    return r, nil
  end
end
