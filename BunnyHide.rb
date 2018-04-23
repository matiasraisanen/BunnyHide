class BunnyHide
  # Simple game of finding a bunny
  
  require "fileutils"

  def initialize
    puts("Let's hide the bunny!")
    $turnCounter = 1
    newGame
  end

  # Create folders, and populate the list of content for wrong files
  def createFolders
    notHeres = [
        "It's not here.","Not here either.","Wrong place.","This is not it.",
        "Look somewhere else.","I don't think this is it either.",
        "Try some other file.","No no no no...","Try again.",
        "Does this look like the secret to you? No... I don't think so.",
        "What exactly are you looking for?","Wanna know where the secret is? Well I can give you a hint... NOT HERE! :-D",
        "I don't think you can find it at all.","Psst... check the other file.","You will never find it.",
        "Your princess is in another castle.","Try some other file.","The secret... well it is not here!",
        "It sure is not here.","Nope","Doesn't look like it's here","What are you doing here?",
        "I heard it looks like a bunny...","Keep looking","Nothing to see here."
    ]

    puts("Writing 99 garbage files...")

    begin
      Dir.mkdir("the_folder")
      for i in 1..10 do
        Dir.mkdir("the_folder/set#{i}")
        for j in 1..10 do
          file = File.open("the_folder/set#{i}/file#{j}.txt","w+")
          file.puts(notHeres[rand(notHeres.length+1)])
          file.close
        end
      end

    rescue
      # If folder exists
      deleteFolder
      retry
    end
  end

  # Create the secret file and hide it
  def hideBunny
    puts("Hiding the secret file...")
    rand1 = rand(1..10)
    rand2 = rand(1..10)
    secretfile = File.open("the_folder/set#{rand1}/file#{rand2}.txt","w")
    secretfile.puts("CONGRATULATIONS!\nYou found the secret!\nYou are the best!")
    secretfile.puts("")
    secretfile.puts("(\\(\\")
    secretfile.puts("(o.o)")
    secretfile.puts("o_\(\"\)\(\"\)")
    secretfile.puts("the secret bunny")
    secretfile.close
    pwd = Dir.pwd
    setTip(rand1, rand2)
    puts("Secret file created somewhere in #{pwd}/the_folder/")
  end

  def setTip(rand1, rand2)
    $folder = rand1
    $file = rand2
  end

  # Delete the game folder
  def deleteFolder
    FileUtils.rm_rf("the_folder")
  end

  # Show a tip
  def showTip
    puts("Psst here is a tip: " + $folder.to_s + "/" + $file.to_s)
    puts("")
  end

  # Print the selected file
  def printFile(set, file)
    begin
      printMe = File.open("the_folder/set#{set}/file#{file}.txt","r")
      puts("")
      puts("Printing #{Dir.pwd}/the_folder/set#{set}/file#{file}.txt")
      printMe.each_line{|row| print row}
      printMe.close
      if File.foreach("the_folder/set#{set}/file#{file}.txt").any?{ |l| l['CONGRATULATIONS'] }
        puts("")
        deleteFolder
        $running = false
      end
    rescue
      puts("Invalid values, try again")
      fileChooser
    else
      $turnCounter += 1
    end
  end

  # Choose a file for printing
  def fileChooser
    if $turnCounter == 11
      showTip
    end
    puts("Round: #{$turnCounter}")
    print("Choose the file set (1-10): ")
    @set = gets.chomp!
    print("Choose the file to print (1-10): ")
    @file = gets.chomp!
    printFile(@set, @file)

  end

  # Start a new game
  def newGame
    puts("New game started")
    createFolders
    hideBunny
    $running = true
    while $running
      fileChooser
    end
  end
end

while true
  puts("MAIN MENU")
  puts("(1) Start Game")
  puts("(2) About")
  puts("(3) Quit")
  print("Make your selection: ")
  input = gets.chomp!

  if input == "1"
    newgame = BunnyHide.new
  elsif input == "2"
    puts("")
    puts("This is a simple game developed by Matias Räisänen in 2018.")
    puts("The game creates 10 folders which contain 10 files each.")
    puts("The game then hides 1 secret file among these 100 files.")
    puts("It is up to the player to find this file.")
    puts("")
    puts("Programmed in April 2018, using ruby.")
    puts("")
  elsif input == "3"
    puts("Thank you for playing!")
    exit
  else
    puts("")
    puts("Invalid selection")
    puts("")
    redo
  end
end
