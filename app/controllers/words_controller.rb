class WordsController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :set_user
  before_action :set_word, only: [:show, :edit, :update, :destroy]

  def index
    @words = Word.select {|x| x.user_id == current_user.id}
    @q = Word.ransack(params[:q])
    @search_results = @q.result(distinct: true)

    if @words.present?
      @random_word = @words.sample
    end
    registered_words_of_the_day
  end

  def to_slack
    registered_words_of_the_day
    terms_of_my_registered_words = []
    @registered_words_of_the_day.each do |words|
      if words.user_id == current_user.id
        terms_of_my_registered_words << words.term
      end
    end
    notify_to_slack(terms_of_my_registered_words)
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
      redirect_to word_path(@word.id), notice: '単語を編集しました'
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

  def registered_words_of_the_day
    today = Date.today
    @registered_words_of_the_day = Word.where(created_at: today.in_time_zone.all_day)
  end

  def notify_to_slack(terms_of_my_registered_words)
    text = <<-EOS
-----------------------------
#{@current_user.name}さんの今日の単語

▼単語
#{terms_of_my_registered_words.join("\n")}
    EOS
    Slack.chat_postMessage text: text, username: "単語登録のお知らせ", channel: "#test_kaoru2"
  end
end
