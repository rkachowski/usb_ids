module UsbIds
  Gem.find_files("usb_ids/**/*.rb").each { |path| require path }

  def self.setup
    @@db = DB.new "usb.db"
  end

  def self.db
    @@db
  end
end

