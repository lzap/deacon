module ForemanNameGenerator
  class MacGenerator < Generator
    def generate(mac, female = false)
      return [] if mac.nil? || mac.empty?
      # B0 B1 B2 B3 B4 B5
      # SHRT0 SHRT1 SHRT2
      bytes = mac_to_bytes(mac)
      shorts = mac_to_shorts(mac)
      filename = (shorts[0] & 0x1) == 0 ? GIVEN_MALE_NAMES_FILE : GIVEN_FEMALE_NAMES_FILE
      firstname1 = find_name(bytes[2], data_file(filename))
      firstname2 = find_name(bytes[3], data_file(filename))
      surname1 = find_name(shorts[0], data_file(SURNAMES_FILE))
      surname2 = find_name(shorts[2], data_file(SURNAMES_FILE))
      [firstname2, firstname1, surname1, surname2]
    end
  end
end
