require 'rack'

require_relative 'queue_handler'
require_relative 'upload_handler'

use Rack::Static,
  urls: ['/csv'],
  root: 'static'

map '/upload' do
  run UploadHandler.new
end

map '/stats' do
  run QueueHandler::Stats.new
end

map '/add' do
  run QueueHandler::Add.new
end

map '/add/error' do
  run QueueHandler::Add.new
end

map '/next' do
  run QueueHandler::Next.new
end

map '/' do
  run QueueHandler::Flush.new
end
