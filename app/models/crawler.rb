require "open-uri"

class Crawler
  def self.crawl
    Link.all.each do |link|
      begin
        html = Nokogiri::HTML(open(link.url))
      rescue
        puts "Error encountered while crawling"
      else
        collect_links(html)
      end
    end
  end

  def collect_links(html)
    hrefs = html.css('a')
    hrefs.each do |href|
      url = href.attributes["href"].value
      new_link = Link.find_or_create_by(url: url)
      new_link.update_attributes(html: html)
    end
  end
end
