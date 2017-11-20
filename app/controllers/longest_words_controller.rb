require 'open-uri'
require 'json'


class LongestWordsController < ApplicationController
  def game
    @game = generate_grid(9)
  end

  def score
    attempt = params[:result]
    grid = params[:grid]
    start_time = params[:start_time].to_i
    end_time = Time.now.to_i

    run_game(attempt, grid, start_time, end_time)
  end

  def generate_grid(grid_size)
    i = 0
    grid = []
    while i < grid_size.to_i
      grid << ("A".."Z").to_a.sample
      i += 1
    end
    grid
  end

  def word_english?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/" + attempt
    JSON.parse(open(url).read)["found"] ? true : false
  end

  def letter_include?(attempt, grid)
    letters = attempt.downcase.split("")
    truth = true
    letters.each do |letter|
      if letters.count(letter) <= grid.downcase.chars.count(letter)
        puts letter
        truth = true
      else
        return false
      end
    end
  end

  def run_game(attempt, grid, start_time, end_time)
    @results = {}
    score = 0
    if word_english?(attempt) == false
    message = "not an english word"
    elsif letter_include?(attempt, grid) == false
    message = "letter not included"
    else
    score = attempt.size.to_i * 10 - (end_time - start_time).to_i
    message = "Message: Well Done!"
    end
    @results[:time] = (end_time - start_time).to_i
    @results[:score] = score
    @results[:message] = message
    return @results
  end

end
