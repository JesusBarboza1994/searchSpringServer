class CodeController < ApplicationController
  def index
    brand = params[:brand]
    model = params[:model]
    position = params[:position]
    start_year = params[:start_year]
    end_year = params[:end_year]
    version = params[:version]
    
    codes = Code.includes(cars: :brand)
    
    codes = codes.joins(cars: :brand).where("brands.name = ?", brand) if brand.present?
    codes = codes.where(cars: { model: model }) if model.present?
    codes = codes.where( version: version ) if version.present?
    if start_year.present? && end_year.present?
      codes = codes.where("cars.end_year >= ? AND cars.init_year <= ?", end_year.to_i, start_year.to_i)
    elsif start_year.present?
      codes = codes.where("cars.init_year >= ?", start_year.to_i)
    elsif end_year.present?
      codes = codes.where("cars.end_year <= ?", end_year.to_i)
    end
    codes = codes.where(position: position) if position.present?
    unique_brands = codes.select("brands.name").distinct.pluck("brands.name")
    unique_models = codes.select("cars.model").distinct.pluck("cars.model")
    unique_versions = codes.select("version").distinct.pluck("version")
    unique_positions = codes.select("position").distinct.pluck("position")
  
  
    page_number = params[:page] || 1
    per_page = params[:per_page] || 12
    paginated_codes = codes.paginate(page: page_number, per_page: per_page)
    total_pages = paginated_codes.total_pages

    render json: {
      codes: paginated_codes.as_json(include: { cars: { include: :brand } }),
      brands: unique_brands.compact.sort,
      models: unique_models.compact.sort,
      versions: unique_versions.compact.sort,
      positions: unique_positions.compact.sort,
      total_pages: total_pages
    }
  end

  def show
    spring = Spring.includes(:code).find_by(code_id: params[:id])
    
    if spring
      stock = ejecutar_consulta_osis(spring.code.osis_code)
      result = spring.attributes.merge('stock' => stock)
      render json: {
        spring: result,
        code: spring.code
      }
    else
      render json: {}, status: :not_found
    end
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
  