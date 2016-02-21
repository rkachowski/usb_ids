module UsbIds
  Gem.find_files("usb_ids/**/*.rb").each { |path| puts path; require path }

  def self.setup
    @@db = DB.new "usbids.db"
  end
end

