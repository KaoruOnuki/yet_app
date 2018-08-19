class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy]
  before_action :redirect_if_not_logged_in

  def index
    @words = Word.all
  end

  def new
    if params[:back]
      @word = Word.new(word_params)
    else
      @word = Word.new
    end
  end

  def create
    @word = Word.new(word_params)
    @word.user_id = current_user.id
    if @word.save
      redirect_to words_path, notice: '単語を登録しました'
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @word.update(word_params)
      redirect_to words_path, notice: '単語を編集しました'
    else
      render 'edit'
    end
  end

  def destroy
    @word.destroy
    redirect_to words_path, notice: '単語を削除しました'
  end

  def confirm
    @word = Word.new(word_params)
    @word.user_id = current_user.id
    render :new if @word.invalid?
  end

  private
  def word_params
    params.require(:word).permit(:term, :memo, :user_id)
  end

  def set_word
    @word = Word.find(params[:id])
  end

  def redirect_if_not_logged_in
    redirect_to new_session_path if !logged_in?
  end
end
