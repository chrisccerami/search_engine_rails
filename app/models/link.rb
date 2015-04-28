class Link < ActiveRecord::Base
  FRESHNESS_PERIOD = 7 * 24 * 60 * 60 # 1 week

  def fresh?
    !last_crawled_at.nil? &&
    Time.now - last_crawled_at < FRESHNESS_PERIOD
  end

  def self.stale
    all.select { |link| !link.fresh? }
  end
end
