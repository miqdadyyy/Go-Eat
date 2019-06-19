require_relative 'Classes/Map'
require_relative 'Modules/StoreModule'


def main(args=nil)
  puts(args)
  puts("Selamat data di Go-Eat")
  puts("1. Show Map")
  puts("2. Order Food")
  puts("3. View History")
  print("Silahkan pilih menu : ")
  menu = gets().chomp.to_i

  case menu
  when 1
    puts("Show Map")
  when 2
    puts("Order food")
  when 3
    puts("View History")
  else
    puts("Menu Tidak valid")
  end

end

map = Map.new()
puts map.stores
# map.showMap


# main()