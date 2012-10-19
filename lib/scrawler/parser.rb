require 'nokogiri'

module Scrawler

  class Parser

    def self.visit(uri)
      page = Scrawler::Downloader.fetch(uri)
      return nil unless page

      doc = Nokogiri::HTML(page[:html])

      # Retrieve page title.
      titles = doc.xpath("//title")
      title = titles.empty? ? "" : titles[0].content.strip

      # Create a page data hash.
      {
        :url => page[:url],
        :title => title,
        :links => doc.xpath("//a")
          .map { |a| a[:href] }
          .reject { |a| a.nil? or a.empty? }
          .map { |a| Scrawler::Crawler.to_uri(page[:url], a) }
          .reject { |a| a.nil? }
          .uniq,
        :styles => doc.xpath("//link")
          .map { |l| l[:href] }
          .reject { |l| l.nil? or l.empty? }
          .map { |l| Scrawler::Crawler.to_uri(page[:url], l) }
          .reject { |a| a.nil? }
          .uniq,
        :scripts => doc.xpath("//script")
          .map { |s| s[:src] }
          .reject { |s| s.nil? or s.empty? }
          .map { |s| Scrawler::Crawler.to_uri(page[:url], s) }
          .reject { |a| a.nil? }
          .uniq,
        :images => doc.xpath("//img")
          .map { |i| i[:src] }
          .reject { |i| i.nil? or i.empty? }
          .map { |i| Scrawler::Crawler.to_uri(page[:url], i) }
          .reject { |a| a.nil? }
          .uniq
      }
    end
    
  end

end