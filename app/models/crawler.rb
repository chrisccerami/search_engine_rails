require "open-uri"

class Crawler
  def self.crawl
    Link.stales.each do |link|
      begin
        html = Nokogiri::HTML(open(link.url))
      rescue
        puts "Error encountered while crawling"
      else
        collect_links(html)
      end
    end
  end

  def self.collect_links(html)
    hrefs = html.css('a')
    hrefs.each do |href|
      begin
        uri = URI.parse(href)
        host = "#{uri.scheme}://#{uri.host}"
        url = format_url(href.attributes["href"].value, host)
        new_link = Link.find_or_create_by(url: url)
        new_link.update_attributes(html: html)
      rescue
        puts "Error in parsing"
      end
    end
  end

  def self.format_url(href, host)
    if href[0..3] == "http" || href[0..4] == "https"
      url = URI.join(URI.escape(href))
    else
      begin
        url = URI.join(host, URI.escape(href))
      rescue
        puts "Error in formatting"
      end
    end
    url.to_s
  end
end
