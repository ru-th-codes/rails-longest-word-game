require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters].chars

    if !in_grid?(@word, @letters)
      @message = "Sorry but #{@word.upcase} can't be built out of #{@letters.join(', ')}"
    elsif !english_word?(@word)
      @message = "Sorry but #{@word.upcase} does not seem to be a valid English word"
    else
      @message = "Congratulations! #{@word.upcase} is a valid English word"
    end
  end

  private

  def in_grid?(word, letters)
    word.upcase.chars.all? do |letter|
      word.upcase.count(letter) <= letters.count(letter)
    end
  end

  def english_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    data = JSON.parse(response)

    data["found"]
  end
end
