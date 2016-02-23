module ForemanNameGenerator
  class Generator
    DEFAULT_DATA_DIR = File.expand_path('../../../data', __FILE__)
    GIVEN_MALE_NAMES_FILE = 'gmnames.txt'
    GIVEN_FEMALE_NAMES_FILE = 'gfnames.txt'
    SURNAMES_FILE = 'srnames.txt'

    def initialize(data_dir = DEFAULT_DATA_DIR)
      @data_dir = data_dir
    end

    private

    def data_file(filename)
      File.join(@data_dir, filename)
    end

    def find_name(index, filename)
      File.open(filename, 'r') do |f|
        f.seek(index * 15)
        f.readline.chomp.strip
      end
    rescue Exception => e
      raise "Error when seeking to #{index} in #{filename}: #{e}"
    end

    def mac_to_bytes(mac)
      mac.split(/[:-]/).collect{|x| x.to_i(16)}
    end

    def mac_to_shorts(mac)
      mac_to_bytes(mac).each_slice(2).collect { |a, b| (a << 8) + b }
    end
  end
end
