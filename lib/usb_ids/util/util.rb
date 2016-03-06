module UsbIds
  module Util
    def hex_or_int value
      if value.is_a? String
        value.to_i(16)
      else
        value
      end
    end

    def get_name_and_code_from_line line
      components = line.split
      code = components.shift
      name = components.join " "

      {code: code, name: name}
    end

    def parse_usb_ids file_path
      contents = File.open(file_path)
      usb_info = []

      contents.each_line do |line|
        next if line.length < 2 or line.chars.first == "#"

        case
          when line.chars[0..1] == %W(\t \t)
            #interface
          when line.chars.first == "\t"
            #device
            usb_info.last[:devices] << get_name_and_code_from_line(line)
          when line.split.first.match(/[0-9a-fA-F]{4}/)
            #vendor
            details = get_name_and_code_from_line line
            details[:devices] = []
            usb_info << details
          else
            puts "wtf is '#{line}'"
        end
      end

      usb_info
    end
  end
end
