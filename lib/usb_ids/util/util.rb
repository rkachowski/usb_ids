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
        next unless line.match(/^\s*[0-9a-fA-F]{4}/)

        case
          when line.match(/^\t\t/)
            #interface
          when line.match(/^\t/)
            #device
            usb_info.last[:devices] << get_name_and_code_from_line(line)
          else
            #vendor
            details = get_name_and_code_from_line line
            details[:devices] = []
            usb_info << details
        end
      end

      usb_info
    end
  end
end
