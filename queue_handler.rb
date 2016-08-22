require 'rack'
require_relative 'queue'
require 'redis'

module QueueHandler
  class Add
    def call(env)
      client = Redis.new
      req = Rack::Request.new(env)
      urls = [req.params["l"], req.params["r"]]
      Queue.add(client, urls)
      [200, {}, []]
    end
  end

  class Next
    def call(env)
      client = Redis.new
      urls = Queue.pop(client)
      headers = { 'Content-Type' => 'application/json' }
      [200, headers, [urls]]
    end
  end
end
