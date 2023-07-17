class CarController < ApplicationController
  def index
    search = params[:search]
    if search
      brands = Brand.all.select do |brand|
        brand.name.downcase.include?(search.strip.downcase)
      end
    else
      brands = Brand.all
    end
    render json: brands
  end

end