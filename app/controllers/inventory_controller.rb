class InventoryController < ApplicationController
  def ejecutar_consulta
    fecha_actual = Time.now
    year= fecha_actual.year.to_s
    month = fecha_actual.strftime('%m') 
    resultados = Inventory.connection.exec_query(
      "SELECT [prd_codprd],[alm_codalm],[ano_codano],[mes_codmes],CONVERT(INT, [spa_salfin]) AS [spa_salfin] 
      FROM [MRC].[dbo].[SALDOS_PRODUCTOS_SPA] 
      WHERE [prd_codprd] = '0000000491' 
      AND ([alm_codalm] = '0055' OR [alm_codalm] = '0010' 
        OR [alm_codalm] = '0025' OR [alm_codalm] = '0037')
      AND [ano_codano] = #{year}
      AND [mes_codmes] = #{month};")
    render json: ({stock: resultados})
  end
end