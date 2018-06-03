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

  # Добавлем найденный тег или создаем и добавлем тег, если его не было
  def add_tag(tag)
    self.hashtags << Hashtag.find_or_create_by(tag: tag)
  end

  # удаляем теги из таблицы hashtags_questions, которых нету в тексте
  def del_tags(tags_ary)
    self.hashtags.each do |t|
      self.hashtags.delete(t) unless tags_ary.include?(t.tag)
    end
  end

  private

  def action_with_tags
    Hashtag.prepare_tags(self)
  end

end
