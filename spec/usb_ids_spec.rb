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

      end
    end
  end


end

