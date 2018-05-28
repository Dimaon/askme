class Hashtag < ApplicationRecord

  has_and_belongs_to_many :questions

  validates :tag, presence: true

  # Получаем из текста массив тегов
  def self.text_to_tags_ary(text)
    text.scan(/#[^\!\?\.\s]+/)
  end
end
