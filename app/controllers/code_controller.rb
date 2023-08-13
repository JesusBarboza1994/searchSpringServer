class CodeController < ApplicationController
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
    spring = Spring.find_by(code_id: id)
    code = Code.find(id)
    stock = ejecutar_consulta_osis(code.osis_code)
    result = spring.attributes.merge('stock' => stock)
    render json: result
  end

  private

  def ejecutar_consulta_osis(osis_code)
    search_code = autocomplete_with_zeros(osis_code)
    query = "SELECT [prd_codprd],[alm_codalm],[prd_desesp],CONVERT(INT, [spa_salfin]) AS [spa_salfin] 
    FROM [MRC].[dbo].[STOCK_POR_ALMACEN_REPORTE_SP1] 
    WHERE [prd_codprd] = #{search_code}
    AND ([alm_codalm] = 'S0055' OR [alm_codalm] = 'S0010');"
    resultados = Inventory.connection.exec_query(query).uniq
    inventario = 0
    resultados.each do |item|
      inventario += item['spa_salfin']
    end
    return inventario
  end

  def autocomplete_with_zeros(number_str)
    number_str = number_str.to_s  # Asegurarse de que sea un string
    zeros_to_add = 10 - number_str.length
    zeros_to_add > 0 ? ('0' * zeros_to_add) + number_str : number_str
  end
end

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
  