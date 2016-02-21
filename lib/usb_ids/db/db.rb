require 'sqlite3'

module UsbIds

  class DB
    def initialize name
      @handle = SQLite3::Database.new name
      @handle.execute_batch @@schema
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

