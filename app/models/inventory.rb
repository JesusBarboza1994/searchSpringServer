class Inventory < ApplicationRecord
  self.abstract_class = true
  establish_connection :remote_sql_server

  self.table_name = 'STOCK_POR_ALMACEN_REPORTE_SP1'
end