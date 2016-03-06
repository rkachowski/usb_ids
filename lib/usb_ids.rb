module UsbIds
  Gem.find_files("usb_ids/**/*.rb").each { |path| require path }

  #use internal db
  def self.setup
    @@db = DB.new "usb.db"
  end

  #Create a new sqlite db at path with usb vendor + device info included
  def self.create path
    db = DB.new path
    db.from_file File.expand_path(File.join(File.dirname(__FILE__),"usb_ids","assets","usb_ids.txt"))
  end

  #Update db at path with data from remote
  def self.update path

  end

  def self.db
    @@db
  end
end

