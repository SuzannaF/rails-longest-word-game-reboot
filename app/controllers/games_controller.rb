ActionDispatch::Session::CookieStore

require 'open-uri'

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    # @letters = Array.new(5) { VOWELS.sample }
    @letters = Array.new(8) { ('A'..'Z').to_a.sample }
    @letters.shuffle!  #sample() is a Array class method which returns a random element or n random elements from the array. Return: a random element or n random elements from the array
  end

  def score

    @word = params[:word].upcase
    @letters = params[:letters].split # split is a String class method in Ruby which is used to split the given string into an array of substrings based on a pattern specified
    @included = included?(@word, @letters)
    @english_word = word?(@word)
    if @included && @english_word
      @score = @word.length.to_i
    end
  end

  private

  def current_user
    @_current_user ||= session[:current_user_id] && User.find_by(id: session[:current_user_id])
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) } # chars is a String class method in Ruby which is used to return an array of characters in str.
  end

  def word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
