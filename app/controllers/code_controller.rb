class CodeController < ApplicationController
  # def index
  #   brand = params[:brand]
  #   model = params[:model]
  #   position = params[:position]
  #   year = params[:year]
  #   version = params[:version]
      
  #   if (brand || model || position || year || version)
  #     filtered_codes = Code.all.select do |code|
  #       code.cars.any? do |car|
  #         brand_exist = brand.blank? || car.brand.name == brand
  #         model_exist = model.blank? || car.model == model
  #         version_exist = version.blank? || car.version == version
  #         year_exist = year.blank? || (code.end_year >= year.to_i && code.init_year <= year.to_i)
  #         brand_exist && model_exist && year_exist && version_exist
  #       end
  #     end
  #   else
  #     filtered_codes = Code.all
  #   end
  #   render json: {
  #     codes: filtered_codes
  #   }
  # end
  # def index
  #   brand = params[:brand]
  #   model = params[:model]
  #   position = params[:position]
  #   year = params[:year]
  #   version = params[:version]
    
  #   codes = Code.includes(cars: :brand)
    
  #   codes = codes.joins(cars: :brand).where("brands.name = ?", brand) if brand.present?
  #   codes = codes.where(cars: { model: model }) if model.present?
  #   codes = codes.where(cars: { version: version }) if version.present?
  #   codes = codes.where("codes.end_year >= ? AND codes.init_year <= ?", year.to_i, year.to_i) if year.present?
    
  #   render json: {
  #     codes: codes
  #   }
  # end
  def index
    brand = params[:brand]
    model = params[:model]
    position = params[:position]
    year = params[:year]
    version = params[:version]
    
    codes = Code.includes(cars: :brand)
    
    codes = codes.joins(cars: :brand).where("brands.name = ?", brand) if brand.present?
    codes = codes.where(cars: { model: model }) if model.present?
    codes = codes.where(cars: { version: version }) if version.present?
    codes = codes.where("codes.end_year >= ? AND codes.init_year <= ?", year.to_i, year.to_i) if year.present?
    codes = codes.where(position: position) if position.present?
    
    render json: {
      codes: codes.as_json(include: { cars: { include: :brand } })
    }
  end

  
  
  

  def show
    id = params[:id]
    spring = Spring.where(code_id: id)
    render json: spring
  end
end