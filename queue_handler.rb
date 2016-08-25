require 'rack'
require_relative 'queue'
require 'redis'

module QueueHandler
  class Add
    def call(env)
      client = Redis.new
      req = Rack::Request.new(env)
      if !req.post?
        return [405, {}, ['Method Not Allowed']]
      end

      p req

      urls = [req.params['l'], req.params['r']]
      err = if req.env['REQUEST_PATH'] == '/add/error'
              Queue.add_error(client, urls)
            else
              Queue.add(client, urls)
            end
      client.quit
      if err
        return [500, {}, []]
      end

      [200, {}, []]
    end
  end

  class Next
    def call(env)
      req = Rack::Request.new(env)
      if !req.post?
        return [405, {}, ['Method Not Allowed']]
      end

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
