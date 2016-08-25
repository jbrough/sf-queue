require 'rack'
require 'csv'
require 'redis'

require_relative 'upload'

# This should be a sepatate service too, as if the uploader crashes
# due to a bad upload or OOM error the whole queue will come down.
class UploadHandler
  def call(env)
    req = Rack::Request.new(env)
    if !req.post?
      return [405, {}, ["Method Not Allowed"]]
    end

    tmp_file = req.params['csv'][:tempfile]
    client = Redis.new
    csv, err = Upload.add(client, tmp_file)
    client.quit
    if err
      return [500, {}, ["ERROR: #{err.message}"]]
    end

    headers = { 'Content-Type' => 'text/csv' }
    [200, headers, [csv]]
  end
end
