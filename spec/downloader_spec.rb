require 'spec_helper'
require 'uri'

module Scrawler
  
  describe Downloader do
    
    it "should download page using http" do
      url = URI.parse("http://shop.github.com/")
      
      page = Scrawler::Downloader.fetch(url)
      page[:url].to_s.should == url.to_s
      page[:html].should_not be_empty
    end
    
    it "should download page using https" do
      url = URI.parse("https://github.com/about")
      
      page = Scrawler::Downloader.fetch(url)
      page[:url].to_s.should == url.to_s
      page[:html].should_not be_empty
    end
    
    it "should follow redirects" do
      url = URI.parse("http://github.com/about")
      
      page = Scrawler::Downloader.fetch(url)
      page[:url].to_s.should == "https://github.com/about"
      page[:html].should_not be_empty
    end
    
    it "should download only HTML files" do
      url = URI.parse("https://github.com/fluidicon.png")
      
      page = Scrawler::Downloader.fetch(url)
      page.should == nil
    end
    
  end
  
end