require 'net/http'

module Scrawler

  class Downloader

    def self.fetch(uri)
      page = nil
  
      i = 0
      while uri
        break if i > 10
        i += 1
    
        http = Net::HTTP.new uri.host, uri.port
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.use_ssl = (uri.scheme == 'https')

        http.start do |agent|
          response = agent.get(uri.path)

          if response['location']
            uri = Scrawler::Crawler.to_uri(uri, response['location'])
            next
          end

          if response.content_type == 'text/html'
            page = {
              :url => uri,
              :html => response.read_body
            }
          end

          # Stops the loop.
          uri = nil
        end
      end

      page
    end

  end

end