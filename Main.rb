# frozen_string_literal: true

require_relative 'Classes/Map'
require_relative 'Modules/StoreModule'
require_relative 'Modules/MapModule'

def main
  @map = Map.new(*ARGV)
  loop do
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
      @map.showMap
      puts('=' * @map.width)
    when 2
      loop do
        # Show Stores
        store = getStore
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
              showOrders(orders)
              puts("Total harga : #{getTotalPrice(orders)}")
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
                menu = getMenu(store, orders)
                puts menu
                !menu.nil? ? orders << menu : break
              end
            when 2
              puts('=' * @map.width)
              puts('Silahkan pilih item untuk mengganti pemesanan : ')
              showOrders(orders)
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
              driver_path_to_store = findingDriver(store)
              store_path_to_user = storeToUser(store)

              puts @map.showMap(driver_path_to_store[:map])
              puts @map.showMap(store_path_to_user[:map])
            else
              break
            end
          end
          break
        end
      end
    when 3
      puts('View History')
    else
      puts('Terima Kasih telah mengakses Go-Eat')
      break
    end
  end
end

def getStore
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

def getMenu(store, _orders)
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

def getTotalPrice(orders)
  total = 0
  orders.each do |order|
    total += order[:price] * order[:quantity]
  end
  total
end

def showOrders(orders)
  puts orders.class
  orders.each_with_index do |order, index|
    puts("#{index + 1}. #{order[:name]} seharga #{order[:price]} (#{order[:quantity]})")
  end
end

def findingDriver(store)
  result = {:driver => nil, :cost => -1, :map => nil}
  @map.drivers.each do |driver|
    temp = MapModule.generateMapPath(@map.map, store.pos, driver.pos)
    result[:driver].nil? || result[:cost] > temp[:cost] ? result = {:driver => driver, :cost => temp[:cost], :map => temp[:map]} : result = result
  end
  result
end

def storeToUser(store)
  temp = MapModule.generateMapPath(@map.map, store.pos, @map.user)
  temp
end

# map = Map.new("map.json")
main
