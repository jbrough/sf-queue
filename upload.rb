require 'csv'
require 'json'
require 'logger'
require 'digest'

require_relative 'queue'

class Upload
  def self.add(client, tmp_file)
    new_csv = ''

    CSV.foreach(tmp_file) do |row|
      if row[0] && row[1]
        new_row = [row[0], row[1], filename(row)]
        client.sadd(Queue::PENDING, new_row.to_json)
        new_csv << CSV.generate_line(new_row)
      end
    end

    client.publish(Queue::PENDING, '')

    return new_csv
  end

  def self.filename(urls)
    md5 = Digest::MD5.new
    md5.update(urls.to_json)
  end
end
