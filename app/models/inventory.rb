class Inventory < ApplicationRecord
  self.abstract_class = true
  establish_connection :remote_sql_server

  self.table_name = 'SALDOS_PRODUCTOS_SPA'
end