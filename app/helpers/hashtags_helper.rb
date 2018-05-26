module HashtagsHelper

  def tag_to_link(text)
    text.gsub(/#[^\!\?\.\s]+/) do |word|
      link_to word, questions_search_path(tag: word.delete('#')), { :class=>"tag" }
    end
  end

end