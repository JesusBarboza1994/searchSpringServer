class CarController < ApplicationController
  def index
    search = params[:search].strip
    if search
      brands = Car.pluck(:brand).uniq.select do |brand|
        brand.downcase.include?(search.downcase)
      end
    else
      brands = Car.pluck(:brand).uniq
    end
    render json: brands
  end

end