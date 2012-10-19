scrawler
========

Simple web crawler which attempts to crawl all pages within one web site and builds a page site map with their corresponding static assets. Far from perfect, feel free to improve or use bits of it to implement your own crawler.

Usage
-----

### As a gem ###

1. Add to Gemfile.
		
		gem "scrawler", :git => "git://github.com/eugenijusr/scrawler.git"
		
2. Initialize crawler with a host name.
		
		crawler = Scrawler::Crawler.new("github.com")
		
3. Crawl.

		crawler.crawl
		
4. Lookup by full URL.

		page = crawler.lookup("https://github.com/about")
		
Lookup will return a page hash like this one:

		page = {
			:url => "https://www.github.com",			# Page URL.
			:title => "GitHub · Social Coding",		# Page title.
			:links => [..],												# Links.
			:styles => [..],											# CSS files files.
			:scripts => [..],											# JavaScript files.
			:images => [..],											# Images.
			:targets => [..],											# Pages this page links to (references to other page hashed).
			:sources => [..]											# Pages linking into this page (references to other page hashes).
		}
		
### As a standalone CLI app ###

1. Clone git repo.

		git clone git@github.com:eugenijusr/scrawler.git
		
2. cd project dir.

		cd scrawler
		
3. Install gem.

		rake install
		
4. Run the app.

		scrawler
		

		