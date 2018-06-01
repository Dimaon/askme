class Hashtag < ApplicationRecord

  has_and_belongs_to_many :questions

  validates :tag, presence: true

  # метод наполняющий массив тегами, которые надо удалить
  # и которые надо добавить/обновить
  def self.prepare_tags(question)
    tags_ary = self.tags_to_ary(question.text_with_tags)
    # Проверяем, есть ли вообще теги в тексте
    if tags_ary.any?
      # Проходимся по массиву тегов и проверяем, есть ли тег в таблице тегов и таблице hashtags_questions
      tags_ary.each do |tag|
        # Пропускаем иттерацию, если тег уже есть
        next if question.hashtags.find_by(tag: tag)
        question.add_tag(tag)
      end
    else
      # удаляем все теги, если их вообще не встретилось в тексте
      question.del_tags(tags_ary)
    end
  end

  private
  # Получаем из текста массив тегов
  def self.tags_to_ary(text_with_tags)
    text_with_tags.scan(/#[^\!\?\.\s]+/)
  end
end
