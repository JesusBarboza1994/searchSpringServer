class CodeController < ApplicationController
  def index
    brand = params[:brand]
    model = params[:model]
    position = params[:position]
    year = params[:year]
    version = params[:version]
      
    if (brand || model || position || year || version)
      filtered_codes = Code.all.select do |code|
        code.cars.any? do |car|
          brand_exist = brand.blank? || car.brand == brand
          model_exist = model.blank? || car.model == model
          version_exist = version.blank? || car.version == version
          year_exist = year.blank? || (code.end_year >= year.to_i && code.init_year <= year.to_i)
          brand_exist && model_exist && year_exist && version
        end
      end
    else
      filtered_codes = Code.all
    end
    render json: {
      codes: filtered_codes
    }
  end

  def show
    id = params[:id]
    spring = Spring.where(code_id: id)
    render json: spring
  end
end