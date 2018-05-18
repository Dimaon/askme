class Question < ApplicationRecord

  belongs_to :user

  belongs_to :author, class_name: 'User', optional: true

  has_and_belongs_to_many :hashtags
  validates :text, presence: true
  validates :text, length: { maximum: 255 }

  after_save :update_tags

  #TODO
  #before_save :convert_tags_into_text

  private

  def update_tags
    text = self.text.to_s + " " + self.answer.to_s
    hash_tags_arr = text.scan(/#[^\!\?\.\s]+/)

    # Проверяем, есть ли вообще теги в тексте
    if hash_tags_arr.any?
      # Проходимся по массиву тегов и проверяем, есть ли тег в таблице тегов и таблице hashtags_questions
      hash_tags_arr.each do |tag|
        # Пропускаем иттерацию, если тег уже есть
        next if self.hashtags.find_by(tag: tag)

        # Добавлем найденный тег или создаем и добавлем тег, если его не было
        hash_tag = Hashtag.find_by(tag: tag) || Hashtag.create(tag: tag)
        self.hashtags << hash_tag
      end

      # удаляем теги из таблицы hashtags_questions, которых нету в тексте
      self.hashtags.each do |t|
         self.hashtags.delete(t) unless hash_tags_arr.include?(t.tag)
      end
    else
      # удаляем все теги, если их вообще не встретилось в тексте
      self.hashtags.delete_all
    end
  end

  #TODO
  # def convert_tags_into_text
  #   string_arr = self.text.split
  #   string_arr.each do |s|
  #     if s.match(/#[^\!\?\.\s\,]+/)
  #       self.text << "<span class='tag'>#{s}</span>"
  #     end
  #   end
  # end

end
