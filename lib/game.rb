class Game
    def initialize
        @secret_word = create_secret_word
        @guesses = []
        @secret_word.split('').each {@guesses << "_"}
        @clone_secret_word = @secret_word.split('').clone
        @incorrect = 0
        @incorrect_guess = []
    end

    def guess_letter
        puts "Enter save and hit enter (twice) to save or guess a letter to continue: "
        guess = gets.chomp
    
        return "save" if guess == "save"

        if guess.length > 1 || guess.match(/\d/) 
            loop do
                puts "Please just enter one letter, no words or numbers: "
                guess = gets.chomp
                break if guess.length == 1 && !guess.match(/\d/) || guess == "save"
            end
        end
        guess
    end

    def display_sublines
        puts @guesses.join(' ').prepend("=>\t")
        puts ""
    end

    def top
        puts ""
        puts "--------"
    end

    def bottom
        puts "------------------"
        puts ""
    end

    def display_hangman(incorrect=0)     
        puts [" |","\t|\n","\t|\n","\t|\n","\t|\n","\t|\n","\t|\n","\t|"] if incorrect == 0      
        puts [" |","( )\t|\n","\t|\n","\t|\n","\t|\n","\t|\n","\t|\n","\t|"] if incorrect == 1
        puts [" |", "( )\t|\n", " |\t|\n", "\t|\n", "\t|\n", "\t|\n", "\t|\n", "\t|"] if incorrect == 2
        puts [" |", "( )\t|\n", "/|", "\t|\n", "\t|\n", "\t|\n", "\t|\n", "\t|"] if incorrect == 3
        puts [" |", "( )\t|\n", "/|\\", "\t|\n", "\t|\n", "\t|\n", "\t|\n", "\t|"] if incorrect == 4
        puts [" |", "( )\t|\n", "/|\\", " |\t|\n", "\t|\n", "\t|\n", "\t|\n", "\t|"] if incorrect == 5
        puts [" |", "( )\t|\n", "/|\\", " |\t|\n", " |\t|\n", "\t|\n", "\t|\n", "\t|"] if incorrect == 6
        puts [" |", "( )\t|\n", "/|\\", " |\t|\n", " |\t|\n", "  \\\t|\n", "\t|\n", "\t|"] if incorrect == 7
        puts [" |", "( )\t|\n", "/|\\", " |\t|\n", " |\t|\n", "/ \\\t|\n", "\t|\n", "\t|"] if incorrect == 8
    end

    def incorrect_guess
        puts "Incorrect letters:"
        puts @incorrect_guess.join(' ')
        puts ""
    end

    def correct?(guess_letter)
        if @secret_word.split('').include?(guess_letter) 
            @secret_word.split('').each.with_index do |item, idx|
                next unless item == guess_letter
                @guesses[idx] = guess_letter
            end
        else
            @incorrect += 1
            @incorrect_guess << guess_letter
        end
    end

    def winner
        if @guesses == @clone_secret_word
            puts ""
            puts "You're the winner, the word is #{@secret_word}" 
            puts "Press a key to exit"
            true
        end
    end

    def loser
        if @incorrect == 8
            puts ""
            puts "You lost the game, the word was #{@secret_word}" 
            puts "Press a key to exit"
            true
        end
    end

    def create_secret_word
        secret_word_pool = []
        File.open("5desk.txt", "r").readlines.each do |line|
            if line.length > 6 && line.length < 12
                secret_word_pool << line
            end
        end
    
        secret_word = secret_word_pool[rand(0..secret_word_pool.length - 1)].chomp
        secret_word.downcase
    end

    def play
        loop do
            top
            display_hangman(@incorrect)
            bottom
            display_sublines
            incorrect_guess
            input = guess_letter
            correct?(input)
            break if input == "save" || winner == true || loser == true
        end
    end
end

