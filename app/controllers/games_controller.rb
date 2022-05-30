require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = [*('A'..'Z')].sample(10).join
  end

  def score
    @answer = params[:answer]
    @grid = params[:letters]
    if included?(@answer.upcase, @grid)
      if english_word?(@answer)
        @score = 'well done'
      else
        @score = 'not an english word'
      end
    else
      @score = 'not in the grid'
    end
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
