class AddLastCrawledAtToLinks < ActiveRecord::Migration
  def change
    add_column :links, :last_crawled_at, :datetime
  end
end
