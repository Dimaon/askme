class Question < ApplicationRecord

  belongs_to :user

  belongs_to :author, class_name: 'User', optional: true

  has_and_belongs_to_many :hashtags
  validates :text, presence: true
  validates :text, length: { maximum: 255 }

  after_save :prepare_tags

  private

  def prepare_tags
    # Проверяем, есть ли вообще теги в тексте
    if text_to_tags.any?
      # Проходимся по массиву тегов и проверяем, есть ли тег в таблице тегов и таблице hashtags_questions
      text_to_tags.each do |tag|
        # Пропускаем иттерацию, если тег уже есть
        next if self.hashtags.find_by(tag: tag)
        add_tag(tag)
      end
      del_tags
    else
      # удаляем все теги, если их вообще не встретилось в тексте
      self.hashtags.delete_all
    end
  end

  # Получаем из текста массив тегов
  def text_to_tags
    text = self.text.to_s + " " + self.answer.to_s
    text.scan(/#[^\!\?\.\s]+/)
  end

  # удаляем теги из таблицы hashtags_questions, которых нету в тексте
  def del_tags
    self.hashtags.each do |t|
      self.hashtags.delete(t) unless text_to_tags.include?(t.tag)
    end
  end

  # Добавлем найденный тег или создаем и добавлем тег, если его не было
  def add_tag(tag)
    hash_tag = Hashtag.find_by(tag: tag) || Hashtag.create(tag: tag)
    self.hashtags << hash_tag
  end
end
