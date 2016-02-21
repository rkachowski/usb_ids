$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'usb_ids'
require "minitest/autorun"

describe UsbIds do
  it "works" do
    assert_equal true, true
  end

  it "makes a db with the appropriate schema " do
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        UsbIds.setup
        assert File.exists?("usbids.db")
      end
    end

  end
end

