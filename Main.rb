require_relative 'Classes/Map'
require_relative 'Modules/StoreModule'


def main(args)
  map =  Map.new(*ARGV)

  while true
    puts("Selamat data di Go-Eat")
    puts("1. Show Map")
    puts("2. Order Food")
    puts("3. View History")
    puts("4. Exit")
    print("Silahkan pilih menu : ")
    menu = gets().chomp.to_i

    case menu
    when 1
      puts("=" * map.width)
      map.showMap
      puts("=" * map.width)
    when 2
      puts("Order food")
    when 3
      puts("View History")
    else
      puts("Terima Kasih telah mengakses Go-Eat")
      break
    end
  end

end

# map = Map.new("map.json")
main(ARGV)