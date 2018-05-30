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
        self.add_tag(question, tag)
      end
    else
      # удаляем все теги, если их вообще не встретилось в тексте
      self.del_tags(question, tags_ary)
    end
  end

  private
  # Получаем из текста массив тегов
  def self.tags_to_ary(text_with_tags)
    text_with_tags.scan(/#[^\!\?\.\s]+/)
  end

  # Добавлем найденный тег или создаем и добавлем тег, если его не было
  def self.add_tag(question, tag)
    hash_tag_to_add = self.find_by(tag: tag) || self.create(tag: tag)
    question.hashtags << hash_tag_to_add
  end

  # удаляем теги из таблицы hashtags_questions, которых нету в тексте
  def self.del_tags(question, tags_ary)
    question.hashtags.each do |t|
      question.hashtags.delete(t) unless tags_ary.include?(t.tag)
    end
  end

end
