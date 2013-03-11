module Spree
  class Post < ActiveRecord::Base

    attr_accessible :title, :meta_keywords, :meta_description, :body, :permalink, :published, :published_at, :tag_list

    validates :title, :presence => true
    validates :permalink, :uniqueness => true

    paginates_per 50

    acts_as_taggable

    extend FriendlyId
    friendly_id :title, use: :slugged, slug_column: :permalink

    scope :published, lambda { where(Post.arel_table[:published_at].lteq(DateTime.now)).order("created_at desc") }

    def self.archives(year, month=nil)
      if month
        start_date = Date.new(year, month)
        end_date = start_date.end_of_month.next_day
      else
        start_date = Date.new(year)
        end_date = start_date.end_of_year
      end
      published.where(published_at: start_date..end_date)
    end

  end
end
