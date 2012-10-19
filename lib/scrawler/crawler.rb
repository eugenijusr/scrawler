require 'uri'

module Scrawler

  class Crawler
    
    def initialize(host)
      @host = host
      @pages = { }
      @aliases = { }
    end
    
    def crawl
      queue = [URI::HTTP.build({:host => @host, :path => "/"})]

      while uri = queue.shift
        print "."
        
        # Check to see whether URL is not visited yet.
        next if (@pages[uri.to_s] or uri.host != @host)

        begin
          # Visit the URL.
          page = Scrawler::Parser.visit(uri)
          
          # Skip if this is not a page.
          next unless page
          
          # Page returns a real URL we got redirected to (if we had).
          real_uri = page[:url]
          
          # Additional check to see whether the real URI is not visited yet.
          if real_uri.to_s != uri.to_s
            # If it's a different host we skip it.
            next if real_uri.host != @host
            
            # We also store links redirecting to this page.
            if @pages[real_uri.to_s]
              @aliases[uri.to_s] = @pages[real_uri.to_s] unless @aliases[uri.to_s]
              next
            end
            
            @aliases[uri.to_s] = page unless @aliases[uri.to_s]
          end
          
          puts
          puts "Indexing " + real_uri.to_s
          
          # Add to page hash.
          @pages[real_uri.to_s] = page
          
          # Add new links to the queue.
          page[:links].each do |l|
            queue.push(l)
          end
        rescue Exception => e
          # Do nothing.
          # puts e.message
          # puts e.backtrace
        end
      end
      
      puts
      puts "Resolving connections between pages..."
      
      # Building page graph - filling :targets and :sources.
      @pages.each_value do |page|
        page[:targets] = [] if page[:targets] == nil
        page[:sources] = [] if page[:sources] == nil
        
        page[:links].each do |link|
          linked_page = @pages[link.to_s]
          linked_page = @aliases[link.to_s] if linked_page == nil
          
          if linked_page
            page[:targets].push(linked_page) unless page[:targets].include?(linked_page)
            linked_page[:sources] = [] if linked_page[:sources] == nil
            linked_page[:sources].push(page) unless linked_page[:sources].include?(page)
          end
        end
      end
      
      puts "Done."
    end
  
    def lookup(url)
      @pages[url]
    end
    
    def self.to_uri(current_uri, link)
      # Testing whether it's foo:bar link (javascript or mailto).
      return nil if link.match(/^.*:[^\/]/)
      
      begin
        # Testing whether this is an absolute link.
        unless link.match(/^.*:\/\//)
          uri = current_uri.clone
          
          # Testing whether it starts with a slash.
          unless link.match(/^\//)
            uri.path = "/" + link
          else
            uri.path = link
          end
        else
          uri = URI.parse(link)
        end
        
        # Remove the fragment section of the URL.
        uri.fragment = nil
        
        uri
      rescue Exception => e
        nil
      end  
    end
  
  end

end