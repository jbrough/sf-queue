require 'csv'
require 'json'
require 'logger'

require_relative 'queue'

class Upload
  def self.add(client, tmp_file)
    begin
      CSV.foreach(tmp_file) do |row|
        if row[0] && row[1]
          v = [row[0], row[1]].to_json
          client.sadd(Queue::NAME, v)
        end
      end
    rescue => e
      Logger.new(STDERR).error(e)
      return e
    end

    return nil
  end
end
