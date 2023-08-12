require 'csv'
brand_file = Rails.root.join('db', 'csv','marca.csv')
car_file = Rails.root.join('db', 'csv','carro.csv')
code_file = Rails.root.join('db', 'csv','codigo.csv')
spring_file = Rails.root.join('db', 'csv','resorte.csv')
car_code_file = Rails.root.join('db', 'csv','carro-codigo.csv')
precios = Rails.root.join('db', 'csv','precios.csv')

puts "START SEEDING - BRANDS"
CSV.foreach(brand_file, headers: true) do |row_brand|
  brand = Brand.new(name: row_brand[2] , img_url:row_brand[3])
  if !brand.save
    brand.errors.full_messages.each do |error|
      puts "#{row_brand[2]} - #{error}"
    end
  end
end
puts "END SEEDING - BRANDS"

puts "START SEEDING - CARS"
CSV.foreach(car_file, headers: true) do |row_car|
  car = Car.new(table_id: row_car[0].to_i,model: row_car[2], year: row_car[3], brand: Brand.find_by(name: row_car[1].strip))
  if !car.save
    car.errors.full_messages.each do |error|
      puts "#{row_car[2]} - #{row_car[1]} - #{error}"
    end
  end
end
puts "END SEEDING - CARS"

puts "START SEEDING - PRICES"
prices = []
CSV.foreach(precios, headers: true) do |row_precio|
  price = {}
  price[row_precio[0]] = row_precio[1]
  prices << price
end
puts "END SEEDING - PRICES"
puts "START SEEDING - CODES"
CSV.foreach(code_file, headers: true) do |row_code|
  if row_code[7].include?("GLP")
    version = 1
  elsif row_code[7].include?("ORIG") 
    version = 0
  elsif row_code[7].include?("GNV") && row_code[7].include?("3")
    version = 2
  elsif row_code[7].include?("GNV") && row_code[7].include?("4")
    version = 3
  elsif row_code[7].include?("GNV") && row_code[7].include?("5")
    version = 4
  elsif row_code[7].include?("REF")
    version = 5
  elsif row_code[7].include?("PROG")
    version = 6
  end
  price = prices.find{|pr| pr.key?(row_code[1])}
  if(price.nil?)
    price = 0
  else
    price = price[row_code[1]].to_f
  end
  code = Code.new(table_id: row_code[0].to_i,osis_code: row_code[1], img_url: row_code[2], position: row_code[3].to_i, price: price, init_year: row_code[5].to_i, end_year: row_code[6].to_i, version: version)
  if !code.save
    code.errors.full_messages.each do |error|
      puts "#{row_code[1]} - #{error}"
    end
  end
end
puts "END SEEDING - CODES"

puts "START SEEDING - SPRINGS"
CSV.foreach(spring_file, headers: true) do |row_spring|
  dext2 = row_spring[3].to_f == "-" ? null : row_spring[3].to_f
  dint1 = row_spring[5].to_f == "-" ? null : row_spring[5].to_f
  dint2 = row_spring[6].to_f == "-" ? null : row_spring[6].to_f
  spring = Spring.new(wire: row_spring[1], dext: row_spring[2], dext2: dext2, coils: row_spring[4], dint1: dint1, dint2: dint2, length: row_spring[7], code: Code.find_by(osis_code: row_spring[8]))
  if !spring.save
    spring.errors.full_messages.each do |error|
      puts "#{row_spring[8]} - #{error}"
    end
  end
end
puts "END SEEDING - SPRINGS"

puts "START SEEDING - CARS_CODES"
CSV.foreach(car_code_file, headers: true) do |row_code|
  car = Car.find_by(table_id: row_code[1])
  if !car
    puts "No existe carro #{row_code[0]}"
  end 
  code = Code.find_by(table_id: row_code[2])
  if !code 
    puts "No existe codigo #{row_code[0]}" 
    puts row_code
  end
  car.codes << code
end
puts "END SEEDING - CARS_CODES"

# brand1 = Brand.create(name: "Kia", img_url:"18LvdIr94K105Vixmn9pcOlneYGIPpiOP")
# brand2 = Brand.create(name: "Volkswagen", img_url:"15wcN0-NOXXLnHe0ju4vMYYl2F2KSURO9")
# car1 = Car.create(brand: brand1, model:"Sorento", year: 2016 )
# car2 = Car.create(brand: brand2, model:"Passat", year: 2013)

# code1 = Code.create(osis_code:"491", position:1, price: 150.4, init_year:2013, end_year: 2017, version:"original")

# code2 = Code.create(osis_code:"7851", position:1, price: 120.5, init_year:2011, end_year: 2015, version:1)

# code3 = Code.create(osis_code:"3596", position:0, price: 98.2, init_year:2011, end_year: 2015, version:2)

# car1.codes << code1
# car2.codes << code2
# car2.codes << code3

# Spring.create(wire:12, dext:120, coils: 5.5, dint1: 65, dint2: 50, length:280, code: code1)
# Spring.create(wire:11.5, dext:100, coils: 7.125, dint1: 65, length:270, code: code2)
# Spring.create(wire:15, dext:98, coils: 8.75, length:300, code: code3)