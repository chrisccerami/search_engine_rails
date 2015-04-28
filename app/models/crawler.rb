require "open-uri"

class Crawler
  def self.crawl
    Link.stale.each do |link|
      begin
        html = Nokogiri::HTML(open(link.url))
      rescue
        puts "Error encountered while crawling"
      else
        collect_links(html, link.url)
        link.update(last_crawled_at: Time.now)
      end
    end
  end

  def self.collect_links(html, url)
    hrefs = html.css('a')
    hrefs.each do |href|
      begin
        uri = URI.parse(url)
        url = format_url(href.attributes["href"].value, uri)
      rescue
        puts "Error in parsing"
      else
        if url.starts_with?("http")
          begin
            new_link = Link.find_or_create_by(url: url)
            new_link.update(html: html)
            puts new_link.url
          rescue
            puts "#{new_link.errors}"
          end
        end
      end
    end
  end

  def self.format_url(href, uri)
    url = URI.join(URI.escape(href))
    if !url.scheme.nil? && url.scheme.starts_with("http")
      return url
    else
      begin
        host = "#{uri.scheme}://#{uri.host}"
        url = URI.join(host, URI.escape(href))
      rescue
        puts "Error in formatting #{uri.scheme}://#{uri.host}#{uri.path}"
      end
    end
    url.to_s
  end
end
