class Visit < ActiveRecord::Base
  attr_accessible :user_id, :shortened_url_id

  validates_presence_of :user_id, :shortened_url_id

  belongs_to(
    :visitors,
    :primary_key => :id,
    :foreign_key => :user_id,
    :class_name => "User"
  )

  belongs_to(
    :visited_urls,
    :primary_key => :id,
    :foreign_key => :shortened_url_id,
    :class_name => "ShortenedUrl"
  )

  def self.record_visit!(user, shortened_url)
    v = Visit.new(:user_id => user.id, :shortened_url_id => shortened_url.id)
    v.save!
  end

end
