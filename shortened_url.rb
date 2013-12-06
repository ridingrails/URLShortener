class ShortenedUrl < ActiveRecord::Base
  include SecureRandom
  attr_accessible :long_url, :short_url, :submitter_id

  validates_presence_of :long_url, :short_url, :submitter_id
  validates_uniqueness_of :short_url

  belongs_to(
    :submitter,
    :primary_key => :id,
    :foreign_key => :submitter_id,
    :class_name => "User"
  )

  has_many(
    :visits,
    :primary_key => :id,
    :foreign_key => :shortened_url_id,
    :class_name => "Visit"
  )

  has_many(
    :url_visitors,
    :through => :visits,
    :source => :visitors,
    :uniq => true
  )


  has_many(
    :taggings,
    :primary_key => :id,
    :foreign_key => :tag_topic_id,
    :class_name  => "Tagging"
  )

  has_many(
    :url_taggings,
    :through => :taggings,
    :source => :tag_topics
  )


  def self.random_code
    SecureRandom.urlsafe_base64
  end

  def self.create_for_user_and_long_url!(long_url, user)
    uniq = false
    while !uniq
      short_url = ShortenedUrl.random_code
      p user.inspect
      new_url_line = ShortenedUrl.new(:long_url => long_url, :submitter_id => user.id,
       :short_url => short_url)
      uniq = true if !ShortenedUrl.exists?(:short_url => short_url)
    end
    new_url_line.save!
  end

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.url_visitors.count
  end

  def num_recent_uniques
    self.url_visitors.where( 'visits.created_at >= ?', 10000.minutes.ago ).count
  end
end

