require 'spec_helper'
require 'uri'

module Scrawler
  
  describe Crawler do
    
    it "should lookup page" do
      crawler = Scrawler::Crawler.new("github.com")
      page_data = {
        :url => "https://github.com/",
        :title => "GitHub"        
      }
      crawler.instance_variable_set(:@pages, {
        "https://github.com/" => page_data
      })
      page = crawler.lookup("https://github.com/")
      page[:url].should == page_data[:url]
      page[:title].should == page_data[:title]
    end
    
    context "when crawling" do
    
      before(:each) do
        parser = double("parser")
      
        @sample_pages = {
          "https://github.com/" => {
            :url => URI.parse("https://github.com/"),
            :title => "Github",
            :links => [
              URI.parse("https://github.com/about")
            ]
          },
          "https://github.com/about" => {
            :url => URI.parse("https://github.com/about"),
            :title => "Github - About",
            :links => []
          }
        }
      
        Scrawler::Parser.stub(:visit).with(URI.parse("http://github.com/")).and_return(@sample_pages["https://github.com/"])
        Scrawler::Parser.stub(:visit).with(URI.parse("https://github.com/about")).and_return(@sample_pages["https://github.com/about"])
        
        @crawler = Scrawler::Crawler.new("github.com")
      end
    
      it "should index pages following links and redirects and setup a page graph" do
        @crawler.crawl
      
        pages = @crawler.instance_variable_get(:@pages)
        aliases = @crawler.instance_variable_get(:@aliases)
        
        pages.count.should == 2
      
        pages["https://github.com/"][:url].to_s.should == @sample_pages["https://github.com/"][:url].to_s
        pages["https://github.com/"][:title].should == @sample_pages["https://github.com/"][:title]
        pages["https://github.com/"][:links][0].to_s.should == @sample_pages["https://github.com/"][:links][0].to_s
        pages["https://github.com/"][:targets].count.should == 1
        pages["https://github.com/"][:sources].count.should == 0
        pages["https://github.com/"][:targets][0].should == pages["https://github.com/about"]
      
        pages["https://github.com/about"][:url].to_s.should == @sample_pages["https://github.com/about"][:url].to_s
        pages["https://github.com/about"][:title].should == @sample_pages["https://github.com/about"][:title]
        pages["https://github.com/about"][:targets].count.should == 0
        pages["https://github.com/about"][:sources].count.should == 1
        pages["https://github.com/about"][:sources][0].should == pages["https://github.com/"]
        
        aliases.count.should == 1
      
        aliases["http://github.com/"] = pages["https://github.com/"]
      end
      
    end
    
    context "when parsing url" do
      
      before(:each) do
        @current_url = URI.parse("https://github.com/about")
      end
      
      it "should build a url from a relative link with a slash in the beginning" do
        url = Scrawler::Crawler.to_uri(@current_url, "/team")
        url.to_s.should == "https://github.com/team"
      end
      
      it "should build a url from a relative link without a slash in the beginning" do
        url = Scrawler::Crawler.to_uri(@current_url, "team")
        url.to_s.should == "https://github.com/team"
      end
      
      it "should build a url from an absolute link" do
        url = Scrawler::Crawler.to_uri(@current_url, "https://github.com/team")
        url.to_s.should == "https://github.com/team"
      end
      
      it "should return nil if link is a javascript:, mail:, etc. link" do
        url = Scrawler::Crawler.to_uri(@current_url, "mailto:help@github.com")
        url.should == nil
      end
      
      it "should return nil if link is invalid" do
        url = Scrawler::Crawler.to_uri(@current_url, '!@#$%^&*')
        url.should == nil
      end
      
    end
    
  end
  
end