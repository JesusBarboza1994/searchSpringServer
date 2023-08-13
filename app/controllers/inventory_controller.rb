class InventoryController < ApplicationController
  def ejecutar_consulta
    resultados = Inventory.connection.exec_query(
      "SELECT [prd_codprd],[alm_codalm],[prd_desesp],CONVERT(INT, [spa_salfin]) AS [spa_salfin] 
      FROM [MRC].[dbo].[STOCK_POR_ALMACEN_REPORTE_SP1] 
      WHERE [prd_codprd] = '0000005616'
      AND ([alm_codalm] = 'S0055' OR [alm_codalm] = 'S0010');").uniq
    inventario = 0
    resultados.each do |item|
      inventario += item['spa_salfin']
    end
    render json: ({stock: inventario})
  end
end