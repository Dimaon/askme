class QuestionsController < ApplicationController
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  before_action :authorize_user, except: [:create, :index, :search]

  def edit
  end

  def search
    @questions = Question.includes(:hashtags).where(hashtags: {tag: "#" + params[:tag]})
    render :index
  end

  def index
    @questions = Question.all
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user if current_user.present?

    if check_captcha(@question) && @question.save
      create_tags_qa(@question.text, @question.answer)
      redirect_to user_path(@question.user), notice: 'Вопрос задан'
    else
      render :edit
    end
  end

  def update
    if @question.update(question_params)
      create_tags_qa(@question.text, @question.answer)
      redirect_to user_path(@question.user), notice: 'Вопрос сохранен'
    else
      render :edit
    end
  end

  # DELETE /questions/1
  def destroy
    user = @question.user
    @question.destroy
    redirect_to user_path(user), notice: 'Вопрос удален'
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  # Принимает текст на вход, если текст содержит #тег, то он сохраняется в модель Hashtag
  def create_tags(text)
    hash_tags_arr = text.scan(/#[^\!\?\.\s]+/)

    if hash_tags_arr.any?
      hash_tags_arr.each do |tag|
        @question.hashtags << Hashtag.create(tag: tag)
      end
    end
  end

  # Вызывает метод create_tags для текста вопроса и теста ответа
  def create_tags_qa(question, answer)
    create_tags(question) unless question.nil?
    create_tags(answer) unless answer.nil?
  end

  def question_params
    # Защита от уязвимости: если текущий пользователь — адресат вопроса,
    # он может менять ответы на вопрос, ему доступно также поле :answer.
    if current_user.present? &&
        params[:question][:user_id].to_i == current_user.id
      params.require(:question).permit(:user_id, :text, :answer)
    else
      params.require(:question).permit(:user_id, :text)
    end
  end

  def authorize_user
    reject_user unless @question.user == current_user
  end

  def check_captcha(model)
    if current_user.present?
      true
    else
      verify_recaptcha(model: model)
    end    
  end
end
