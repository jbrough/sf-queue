require 'rack'

require_relative 'queue_handler'

map '/add' do
  run QueueHandler::Add.new
end

map '/next' do
  run QueueHandler::Next.new
end
