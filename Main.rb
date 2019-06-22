# frozen_string_literal: true

require_relative 'Classes/Map'
require_relative 'Modules/StoreModule'
require_relative 'Modules/MapModule'

@cost_per_unit = 300

def main
  @map = Map.new(*ARGV)
  loop do
    check_drivers()
    puts('Selamat data di Go-Eat')
    puts('1. Show Map')
    puts('2. Order Food')
    puts('3. View History')
    puts('4. Exit')
    print('Silahkan pilih menu : ')
    main_menu = STDIN.gets.chomp.to_i
    case main_menu
    when 1
      puts('=' * @map.width)
      @map.show_map
      puts('=' * @map.width)
    when 2
      loop do
        # Show Stores
        store = get_store
        if store.nil?
          break
        else
          orders = []
          loop do
            puts('=' * @map.width)
            puts("Selamat datang di #{store.name}")
            # Show Orders
            unless orders.empty?
              puts('Menu yang anda pesan adalah : ')
              show_orders(orders)
              puts("Total harga : #{get_total_price(orders)}")
            end
            puts('=' * @map.width)
            puts('Menu : ')
            puts('1. Tambah Item')
            puts('2. Ubah Item')
            puts('3. Order')
            puts('4. Cancel')
            print('Pilih menu : ')
            menu_store = STDIN.gets.chomp.to_i

            case menu_store
            when 1
              loop do
                menu = get_menu(store, orders)
                !menu.nil? ? orders << menu : break
              end
            when 2
              puts('=' * @map.width)
              puts('Silahkan pilih item untuk mengganti pemesanan : ')
              show_orders(orders)
              print('Pilih menu : ')
              menu_change = STDIN.gets.chomp.to_i
              if !orders[menu_change - 1].nil?
                print('Silahkan ubah quantity : ')
                qty = STDIN.gets.chomp.to_i
                qty <= 0 ? orders.delete_at(menu_change - 1) : orders[menu_change - 1][:quantity] = qty
              else
                break
              end
            when 3
              if (orders.size == 0)
                puts('=' * @map.width)
                puts('Anda belum memesan apapun')
                next
              end

              driver_path_to_store = finding_driver(store)
              driver = driver_path_to_store[:driver]
              store_path_to_user = store_to_user(store, driver_path_to_store[:map])

              cost = store_path_to_user[:cost]
              puts("Biaya pengantaran adalah #{cost * @cost_per_unit} dengan rute sebagai berikut : ")
              puts @map.show_map(store_path_to_user[:map])
              puts('=' * @map.width)
              puts("Sehingga total biaya adalah #{get_total_price(orders) + cost * @cost_per_unit} ")
              print('Apakah anda yakin akan memesan? (y/n) : ')
              ans = STDIN.gets.chomp
              if ans == 'y'
                print("Beri rating pada driver #{driver.name} (1-5) : ")
                rating = STDIN.gets.chomp.to_i % 5 + 1
                driver.add_rating(rating)
                puts('Terima kasih telah memesan makanan menggunakan Go-Eat')
                puts('=' * @map.width)
                write_transaction_to_file({store: store, orders: orders, :cost => get_total_price(orders) + cost * @cost_per_unit})
              end
              break
            else
              break
            end
          end
          break
        end
      end
    when 3
      puts('=' * @map.width)
      read_transaction
      puts('=' * @map.width)
    else
      puts('Terima Kasih telah mengakses Go-Eat')
      break
    end
  end
end

def get_store
  stores = @map.stores
  puts('=' * @map.width)
  puts('Daftar toko : ')
  stores.each_with_index do |store, index|
    puts("#{index + 1}. #{store.name}")
  end
  puts("#{stores.size + 1}. Exit")
  print('Silahkan pilih toko : ')
  store_menu = STDIN.gets.chomp.to_i
  store = stores[store_menu - 1]
end

def get_menu(store, _orders)
  # Show Menus
  menus = store.menus
  menus.each_with_index do |menu, index|
    puts("#{index + 1}. #{menu[:name]} (#{menu[:price]})")
  end
  puts("#{menus.size + 1}. Exit")
  print('Silahkan pilih menu : ')
  menu_choice = STDIN.gets.chomp.to_i
  menu = menus[menu_choice - 1]
  return nil if menu.nil?

  print('Masukan jumlah menu yang dipesan : ')
  quantity = STDIN.gets.chomp.to_i
  menu[:quantity] = quantity
  puts('=' * @map.width)
  menu
end

def get_total_price(orders)
  total = 0
  orders.each do |order|
    total += order[:price] * order[:quantity]
  end
  total
end

def show_orders(orders)
  puts orders.class
  orders.each_with_index do |order, index|
    puts("#{index + 1}. #{order[:name]} seharga #{order[:price]} (#{order[:quantity]})")
  end
end

def finding_driver(store)
  result = {:driver => nil, :cost => -1, :map => nil}
  @map.drivers.each do |driver|
    temp = MapModule.generateMapPath(@map.map, store.pos, driver.pos)
    result[:driver].nil? || result[:cost] > temp[:cost] ? result = {:driver => driver, :cost => temp[:cost], :map => temp[:map]} : result = result
  end
  result
end

def store_to_user(store, map = @map.map)
  temp = MapModule.generateMapPath(map, store.pos, @map.user)
  temp
end

def check_drivers
  @map.drivers.each do |driver|
    if driver.rating < 3 && driver.ratings.size != 0
      @map.map[driver.pos[:y]][driver.pos[:x]] = '.'
      @map.drivers.delete(driver)
      @map.generate_map_random(1, 'D')
    end
  end
end

def write_transaction_to_file(data)
  new_data = {
      "store" => data[:store].name,
      "menus" => data[:orders],
      "cost" => data[:cost]
  }

  file = File.open('Data/transaction.json', 'r')
  current_data = JSON.parse(file.read) << new_data
  File.open('Data/transaction.json', 'w+') {|f| f.puts(JSON.pretty_generate(current_data))}
end

def read_transaction()
  file = File.open('Data/transaction.json', 'r+')
  current_data = JSON.parse(file.read, :symbolize_names => true)
  current_data.each_with_index do |data, index|
    # puts data
    puts("#{index + 1}. #{data[:store]} : ")
    data[:menus].each {|menu| puts "#{menu[:name]} (#{menu[:quantity]}) harga per unit #{menu[:price]}"}
    puts "Biaya : #{data[:cost]}"
    puts
  end
end

# map = Map.new("map.json")
main