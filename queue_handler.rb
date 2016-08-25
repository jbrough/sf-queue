require 'rack'
require 'redis'
require 'json'

require_relative 'queue'

module QueueHandler
  class Stats
    def call(env)
      client = Redis.new
      req = Rack::Request.new(env)

      stats = Queue.stats(client).to_json
      client.quit

      headers = { 'Content-Type' => 'application/json' }
      [200, headers, [stats]]
    end
  end

  class Add
    def call(env)
      client = Redis.new
      req = Rack::Request.new(env)
      if !req.post?
        return [405, {}, ['Method Not Allowed']]
      end

      urls = [req.params['l'], req.params['r']]
      if req.env['REQUEST_PATH'] == '/add/error'
        Queue.add_error(client, urls)
      else
        Queue.add(client, urls)
      end

      client.quit

      [201, {}, []]
    end
  end

  class Next
    def call(env)
      req = Rack::Request.new(env)
      if !req.post?
        return [405, {}, ['Method Not Allowed']]
      end

      client = Redis.new
      urls = Queue.pop(client)

      client.quit

      headers = { 'Content-Type' => 'application/json' }
      [200, headers, [urls]]
    end
  end
end
