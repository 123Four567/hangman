require_relative 'game.rb'
require 'yaml'

def save_game(current_game)
    save = YAML.dump(current_game)
    File.open("save_file.yaml", "w") {|file| file.write save}
    true
end

def load_game
    saved = File.open("save_file.yaml", "r")
    load_game = YAML.load(saved)
    saved.close
    load_game
end
puts "Welcome to Hangman! Would you like to play a new game or load in a previous game?"

puts "1) New Game"

puts "2) Load game"

selection = gets.chomp

if selection.length > 1 || selection.match(/[1-2]/) == nil
    loop do
        puts "Please select 1 or 2"
        selection = gets.chomp
        break if selection.length == 1 && selection.match(/[1-2]/) 
    end
end

game = Game.new

if selection == "1"
    game.play    
elsif selection == "2"
    if File.exist?("save_file.yaml")
        load_game.play
    else
        puts "There are no saved game"
        loop do
            puts "Please select 1 or 2"
            selection = gets.chomp
            break if selection.length == 1 && selection.match(/[1-2]/) 
        end
    end
end 

if game.guess_letter == "save"
    File.delete("save_file.yaml")
    save_game(game)
end