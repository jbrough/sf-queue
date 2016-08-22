require 'rack'
require 'csv'
require 'redis'

require_relative 'upload'

class UploadHandler
  def call(env)
    req = Rack::Request.new(env)
    if !req.post?
      return [405, {}, ["Method Not Allowed"]]
    end

    tmp_file = req.params['csv'][:tempfile]
    client = Redis.new
    err = Upload.add(client, tmp_file)
    client.quit
    if err
      return [500, {}, ["ERROR: #{err.message}"]]
    end

    [200, {}, ['OK']]
  end
end
