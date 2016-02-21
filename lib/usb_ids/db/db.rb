require "sqlite3"
require_relative "../util/util"
module UsbIds

  class DB
    include Util

    def initialize name
      @handle = SQLite3::Database.new name
      @handle.results_as_hash = true
      @handle.execute_batch @@schema
    end

    def add_vendor code, name
      @handle.execute "INSERT INTO vendors (code,name) values (#{hex_or_int(code)}, '#{name}');"
    end

    def get_vendor option
      where_clause = []

      option.each do |key, value|
        key = key.to_s
        case key
          when 'code'
            where_clause << "code = #{hex_or_int(value)}"
          when 'name'
            where_clause << "name = '#{value}'"
          else
            return Hash.new(nil)
        end
      end

      result = @handle.execute("SELECT * FROM vendors WHERE #{where_clause.join(" AND ")} LIMIT 1;").first

      return result || Hash.new(nil)
    end

    def add_device vendor_code, code, name
      vendor_id = @handle.execute("SELECT id from vendors where code = #{hex_or_int(vendor_code)};").first
      raise "Vendor id not found in db for vendor code #{vendor_code}" unless vendor_id['id']

      @handle.execute "INSERT INTO devices (vendor_id, code, name) values (#{vendor_id['id']}, #{hex_or_int(code)}, '#{name}');"
    end

    def get_device option
      where_clause = []

      option.each do |key, value|
        key = key.to_s
        case key
          when 'vendor_name'
            vendor = get_vendor :name => value
            next unless vendor['id']

            where_clause << "vendor_id = #{vendor['id']}"
          when 'vendor_code'
            vendor = get_vendor :code => value
            next unless vendor['id']

            where_clause << "vendor_id = #{vendor['id']}"
          when 'code'
            where_clause << "code = #{hex_or_int(value)}"
          when 'name'
            where_clause << "name = '#{value}'"
        end
      end

      @handle.execute("SELECT * from devices WHERE #{where_clause.join(" and ")}")
    end

    def set_update etag

    end

    @@schema = '
CREATE TABLE IF NOT EXISTS vendors  (
  id    integer primary key,
  code integer not null,
  name  text not null
);

CREATE TABLE IF NOT EXISTS devices (
  id integer primary key,
  vendor_id integer not null,
  code integer not null,
  name text not null,

  FOREIGN KEY(vendor_id) REFERENCES vendors(id)
);

CREATE TABLE IF NOT EXISTS meta (
  id integer primary key,
  etag text not null,
  last_update DATETIME DEFAULT CURRENT_TIMESTAMP not null
);

'
  end
end

