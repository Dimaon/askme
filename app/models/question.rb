class Question < ApplicationRecord

  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true
  has_and_belongs_to_many :hashtags

  validates :text, presence: true
  validates :text, length: { maximum: 255 }

  after_save :action_with_tags


  def text_with_tags
    self.text.to_s + " " + self.answer.to_s
  end

  private
  def action_with_tags
    Hashtag.prepare_tags(self)
  end
end
