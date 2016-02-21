module UsbIds
  module Util
    def hex_or_int value
      if value.is_a? String
        value.to_i(16)
      else
        value
      end
    end
  end
end
