require 'spec_helper'
require 'uri'

module Scrawler
  
  describe Parser do
    
    before(:each) do
      downloader = double("downloader")      
      @url = URI.parse("https://github.com/")
      @html = 
        '<html>' +
        '<head>' +
        '<link href="style.css" />' +
        '<script src="script.js" />' +
        '<title>Title</title>' +
        '</head>' +
        '<body>' +
        '<a href="link"></a>' +
        '<img src="image.jpg" />' +
        '</body>' +
        '</html>'
      Scrawler::Downloader.stub(:fetch).with(@url).and_return({ :url => @url, :html => @html })
    end
    
    it "should set url" do
      page = Scrawler::Parser.visit(@url)
      page[:url].to_s.should == @url.to_s
    end
    
    it "should extract title" do
      page = Scrawler::Parser.visit(@url)
      page[:title].should == "Title"
    end
    
    it "should extract links" do
      page = Scrawler::Parser.visit(@url)
      page[:links].count.should == 1
      page[:links][0].to_s.should == "https://github.com/link"
    end
    
    it "should extract styles" do
      page = Scrawler::Parser.visit(@url)
      page[:styles].count.should == 1
      page[:styles][0].to_s.should == "https://github.com/style.css"
    end
    
    it "should extract scripts" do
      page = Scrawler::Parser.visit(@url)
      page[:scripts].count.should == 1
      page[:scripts][0].to_s.should == "https://github.com/script.js"
    end
    
    it "should extract images" do
      page = Scrawler::Parser.visit(@url)
      page[:images].count.should == 1
      page[:images][0].to_s.should == "https://github.com/image.jpg"
    end
    
  end
  
end