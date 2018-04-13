class UsersController < ApplicationController
  def index
    @users = [
      User.new(
        id: 1,
        name: 'Dima',
        username: 'dimaon',
        avatar_url: 'http://digitalspyuk.cdnds.net/17/25/980x490/landscape-1498216547-avatar-neytiri.jpg',
      ),
      User.new(
        id: 2,
        name: 'Nastya',
        username: 'chudo',
        avatar_url: 'http://digitalspyuk.cdnds.net/17/25/980x490/landscape-1498216547-avatar-neytiri.jpg',
      )
    ]
  end

  def new
  end

  def edit
  end

  def show
    @user =
      User.new(
        name: 'Dima',
        username: 'dimaon',
        avatar_url: 'http://digitalspyuk.cdnds.net/17/25/980x490/landscape-1498216547-avatar-neytiri.jpg'
      )

    @questions = [
        Question.new(text: "Текст вопроса 1", created_at: Date.parse('27.03.2018')),
        Question.new(text: "Текст вопроса 1", created_at: Date.parse('27.03.2018')),
        Question.new(text: "Текст вопроса 1", created_at: Date.parse('27.03.2018')),
    ]

    @new_question = Question.new
  end
end
