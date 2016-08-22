require 'rack'
require_relative 'queue'
require 'redis'

module QueueHandler
  class Add
    def call(env)
      client = Redis.new
      req = Rack::Request.new(env)
      urls = [req.params["l"], req.params["r"]]
      err = Queue.add(client, urls)
      client.quit
      if err
        return [500, {}, []]
      end

      [200, {}, []]
    end
  end

  class Next
    def call(env)
      client = Redis.new
      urls, err = Queue.pop(client)
      client.quit
      if err
        return [500, {}, []]
      end

      headers = { 'Content-Type' => 'application/json' }
      [200, headers, [urls]]
    end
  end
end
