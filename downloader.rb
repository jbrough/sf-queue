require 'logger'
require 'em-http-request'

class Downloader
  def self.download(urls)
    bufs = {}
		log = Logger.new(STDERR)

		EventMachine.run do
			multi = EventMachine::MultiRequest.new

			EM::Iterator.new(urls, 2).each do |url, iterator|
				http = EventMachine::HttpRequest.new(url).get
				http.errback do
					host = URI(url).host
					log.error("Failed connection to #{host}")
					bufs[url] = [nil, "Error"]
				end
				http.callback do
					status = http.response_header.status
					if status != 200
						log.error("HTTP #{status} downloading #{url}")
						bufs[url] = [nil, "Error"]
					else
						bufs[url] = [http.response, nil]
					end
					iterator.next
				end
				multi.add(url, http)
				multi.callback { EventMachine.stop } if url == urls.last
			end
		end

		ret1 = bufs[urls[0]]
		ret2 = bufs[urls[1]]

		if ret1[1] || ret2[1]
			return nil, nil, "Error Downloading Image"
		end

		return ret1[0], ret2[0], nil
	end
end
