$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'usb_ids'
require "minitest/autorun"

describe UsbIds do
  it "works" do
    assert_equal true, true
  end

  it "makes a db" do
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        UsbIds.setup
        refute_nil UsbIds.db, "db should be instantiated"
        assert File.exists?("usb.db"), "db file should be present"
      end
    end
  end

  it "adds and gets vendors correctly" do
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        UsbIds.setup

        db = UsbIds.db

        db.add_vendor 7, "test vendor"
        db.add_vendor 0xff, "test vendor 0xff"
        db.add_vendor "0xda", "test vendor 0xda (string)"

        vendor = db.get_vendor :code => 7
        assert_equal vendor['name'], "test vendor"

        vendor = db.get_vendor :name => "test vendor"
        assert_equal vendor['name'], "test vendor"
        assert_equal vendor['code'], 7

        vendor = db.get_vendor :code => 255
        assert_equal vendor['name'], "test vendor 0xff"

        vendor = db.get_vendor :code => 218
        assert_equal vendor['name'], "test vendor 0xda (string)"

        vendor = db.get_vendor :name => "non existent name"
        assert_equal vendor['name'], nil, "shouldn't explode when vendor doesn't exist"
      end
    end
  end

  it "adds and gets devices correctly" do
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        UsbIds.setup

        db = UsbIds.db

        db.add_vendor 3, "test vendor"
        db.add_device 3, 10, "test device"
        db.add_device 3, 11, "test device2"

        db.add_vendor 4, "test vendor 2"
        db.add_device 4, 9, "test device v2"
        db.add_device 4, 11, "test device2 v2"

        devices = db.get_devices :code => 10
        assert_equal 1, devices.size, "should get only one device"
        assert_equal "test device", devices.first['name']

        devices = db.get_devices :vendor_name => "test vendor"
        assert_equal 2, devices.size, "should get all devices for vendor"

        devices = db.get_devices :code => 11
        assert_equal 2, devices.size, "should get devices with same codes from different vendors"

      end
    end
  end

  it "parses source file correctly" do
    file_path = File.expand_path(File.join(File.dirname(__FILE__),"ids_test.txt"))
    test_object = Object.new
    test_object.extend(UsbIds::Util)
    result = test_object.parse_usb_ids file_path

    assert_equal "03ed", result.last[:code]
  end

  it "populates a db correctly from a source file" do
    file_path = File.expand_path(File.join(File.dirname(__FILE__),"ids_test.txt"))

    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        UsbIds.setup

        db = UsbIds.db

        db.from_file file_path
        vendor = db.get_vendor code: "0386"

        assert_equal "LTS", vendor['name']

        devices = db.get_devices code: "7800"
        assert_equal "Mini Album", devices.first['name']
      end
    end
  end

end

