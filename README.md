# Go-Eat
For the compfest software engineering academy.

## Usage :
``` 
ruby Main.rb "map.json"
```
> Starts the program with a predefined map name.

``` 
ruby Main.rb n x y
```
> Starts the program with nxn spaces, and puts the user position in (x,y).

``` 
ruby Main.rb
```
Starts the program with 20x20 maps, randoms the user position.


## Assumption
First of all user has 4 menus that is Show Map, Order, Transaction History and Exit. When user choose show map that will show map around that user as recruitment above. There is some stores that  initial by S and some drivers that have initial D and U thats mean your position on map. When user choose order user should choose the stores which exists on map and add some menu on that store if user want to order. User also can edit the orders which he added. When everything is completed user should pick order menu on that store and user will be shown a map where should driver go from his position to store and to user position. After order is complete user should give rating to driver, when driver has rating under 3 he will deleted on map and generate a new driver on map.
And user also can show his order history on Show History menu on Go-Eat

## Directory Structure
```
├── Classes
│   ├── Driver.rb
│   ├── Map.rb
│   └── Store.rb
├── Data
│   ├── driver_name.json
│   ├── map.json
│   ├── store_menu.json
│   ├── store_name.json
│   └── transaction.json
├── Main.rb
└── Modules
    ├── DriverModule.rb
    ├── MapModule.rb
    └── StoreModule.rb
```
