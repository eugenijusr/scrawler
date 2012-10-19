Gem::Specification.new do |s|
  s.name              = "scrawler"
  s.version           = "1.0.0"
  s.platform          = Gem::Platform::RUBY
  s.authors           = ["Eugenijus Radlinskas"]
  s.email             = ["mail@eugene.lt"]
  s.summary           = "Simple web crawler app"
  s.description       = "Simple web crawler which attempts to crawl all pages within one web site and builds a page sitemap with their corresponding static assets."
  s.homepage          = "http://www.eugene.lt"
  s.files             = ["lib/scrawler.rb", "lib/scrawler/downloader.rb", "lib/scrawler/parser.rb", "lib/scrawler/crawler.rb"]
  s.executables       = ["scrawler"]
  s.test_files        = []
  s.require_paths     = ["lib"]
end