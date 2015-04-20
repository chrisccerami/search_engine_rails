class Link < ActiveRecord::Base
  FRESHNESS_PERIOD = 7 * 24 * 60 * 60 # 1 week

  def fresh?
    Time.now - self.updated_at < FRESHNESS_PERIOD
  end

  def self.stales
    all.select { |link| !link.fresh? }
  end
end
