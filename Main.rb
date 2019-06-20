require_relative 'Classes/Map'
require_relative 'Modules/StoreModule'


def main()
  @map =  Map.new(*ARGV)
  while true
    puts("Selamat data di Go-Eat")
    puts("1. Show Map")
    puts("2. Order Food")
    puts("3. View History")
    puts("4. Exit")
    print("Silahkan pilih menu : ")
    main_menu = STDIN.gets.chomp.to_i
    case main_menu
    when 1
      puts("=" * @map.width)
      @map.showMap
      puts("=" * @map.width)
    when 2
      while true
        # Show Stores
        store = getStore()
        if(store.nil?)
          break
        else
          orders = []
          while true
            puts("=" * @map.width)
            puts("Selamat datang di #{store.name}")
            # Show Orders
            if(orders.size != 0)
              puts("Menu yang anda pesan adalah : ")
              showOrders(orders)
              puts("Total harga : #{getTotalPrice(orders)}")
            end
            puts("=" * @map.width)
            puts("Menu : ")
            puts("1. Tambah Item")
            puts("2. Ubah Item")
            puts("3. Order")
            puts("4. Cancel")
            print("Pilih menu : ")
            menu_store = STDIN.gets().chomp.to_i

            case menu_store
            when 1
              while true
                menu = getMenu(store, orders)
                puts menu
                if(!menu.nil?)
                  orders << menu
                else
                  break
                end
              end
            when 2
              puts("=" * @map.width)
              puts("Silahkan pilih item untuk mengganti pemesanan : ")
              showOrders(orders)
              print("Pilih menu : ")
              menu_change = STDIN.gets().chomp.to_i
              if(!orders[menu_change-1].nil?)
                print("Silahkan ubah quantity : ")
                qty = STDIN.gets().chomp.to_i
                if(qty <= 0)
                  orders.delete_at(menu_change-1)
                else
                  orders[menu_change-1][:quantity] = qty
                end
              else
                break
              end
            when 3
              puts("Order")
            else
              break
            end
          end
          break
        end

      end
    when 3
      puts("View History")
    else
      puts("Terima Kasih telah mengakses Go-Eat")
      break
    end
  end
end

def getStore()
  stores = @map.stores
  puts("=" * @map.width)
  puts("Daftar toko : ")
  stores.each_with_index do |store, index|
    puts("#{index+1}. #{store.name}")
  end
  puts("#{stores.size+1}. Exit")
  print("Silahkan pilih toko : ")
  store_menu = STDIN.gets().chomp.to_i
  store = stores[store_menu-1]
end

def getMenu(store, orders)
  # Show Menus
  menus = store.menus
  menus.each_with_index do |menu, index|
    puts("#{index+1}. #{menu[:name]} (#{menu[:price]})")
  end
  puts("#{menus.size+1}. Exit")
  print("Silahkan pilih menu : ")
  menu_choice = STDIN.gets().chomp.to_i
  menu = menus[menu_choice-1]
  if(menu.nil?)
    return nil
  end

  print("Masukan jumlah menu yang dipesan : ")
  quantity = STDIN.gets().chomp.to_i
  menu[:quantity] = quantity
  puts("=" * @map.width)
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
    puts("#{index+1}. #{order[:name]} seharga #{order[:price]} (#{order[:quantity]})")
  end
end
# map = Map.new("map.json")
main()