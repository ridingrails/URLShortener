class TagTopic < ActiveRecord::Base
  attr_accessible :topic

  has_many(:taggings,
           :primary_key => :id,
           :foreign_key => :tag_topic_id,
           :class_name => "Tagging"
           )

  has_many(:urls_been_tagged,
           :through => :taggings,
           :source => :shortened_urls
            )

end
