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

    if @question.save
      create_tags(@question.text)
      create_tags(@question.answer)
      redirect_to user_path(@question.user), notice: 'Вопрос задан'
    else
      render :edit
    end
  end

  def update
    if @question.update(question_params)
      create_tags(@question.text)
      create_tags(@question.answer)
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

  def create_tags(text)
    hash_tags_arr = text.scan(/#[^\!\?\.\s]+/)

    if hash_tags_arr.any?
      hash_tags_arr.each do |tag|
        @question.hashtags << Hashtag.create(tag: tag)
      end
    end
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
end
