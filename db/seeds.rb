# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
brand1 = Brand.create(name: "Kia", img_url:"18LvdIr94K105Vixmn9pcOlneYGIPpiOP")
brand2 = Brand.create(name: "Volkswagen", img_url:"15wcN0-NOXXLnHe0ju4vMYYl2F2KSURO9")
car1 = Car.create(brand: brand1, model:"Sorento", year: 2016 )
car2 = Car.create(brand: brand2, model:"Passat", year: 2013)

code1 = Code.create(osis_code:"491", position:1, price: 150.4, init_year:2013, end_year: 2017, version:"original")

code2 = Code.create(osis_code:"7851", position:1, price: 120.5, init_year:2011, end_year: 2015, version:1)

code3 = Code.create(osis_code:"3596", position:0, price: 98.2, init_year:2011, end_year: 2015, version:2)

car1.codes << code1
car2.codes << code2
car2.codes << code3

Spring.create(wire:12, dext:120, coils: 5.5, dint1: 65, dint2: 50, length:280, code: code1)
Spring.create(wire:11.5, dext:100, coils: 7.125, dint1: 65, length:270, code: code2)
Spring.create(wire:15, dext:98, coils: 8.75, length:300, code: code3)