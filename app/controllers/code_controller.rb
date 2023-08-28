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
      codes = codes.joins(cars: :brand).where("cars.end_year >= ? AND cars.init_year <= ?", end_year.to_i, start_year.to_i)
    elsif start_year.present? && !end_year.present?
      codes = codes.joins(cars: :brand).where("cars.init_year <= ? AND cars.end_year >= ?", start_year.to_i, start_year.to_i)
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
    puts "SEARCH CODE"
    puts search_code
    fecha_actual = Time.now
    year= fecha_actual.year.to_s
    month = fecha_actual.strftime('%m') 
    query = "SELECT [prd_codprd],[alm_codalm],[ano_codano],[mes_codmes],CONVERT(INT, [spa_salfin]) AS [spa_salfin] 
    FROM [MRC].[dbo].[SALDOS_PRODUCTOS_SPA] 
    WHERE [prd_codprd] = '#{search_code.to_s}'
    AND ([alm_codalm] = '0055' OR [alm_codalm] = '0010' 
      OR [alm_codalm] = '0025' OR [alm_codalm] = '0037')
    AND [ano_codano] = #{year}
    AND [mes_codmes] = #{month};"
    data = Inventory.connection.exec_query(query).uniq
    resultados = {}
    data.each do |item|
      alm_codalm = item["alm_codalm"]
      spa_salfin = item["spa_salfin"]
      resultados[alm_codalm] = spa_salfin
    end
    return resultados

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
  