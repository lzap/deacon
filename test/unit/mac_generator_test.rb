require 'test_plugin_helper'

class MacGeneratorTest < ActiveSupport::TestCase
  setup do
    dir = File.expand_path('../../../data', __FILE__)
    @generator = ForemanNameGenerator::MacGenerator.new(dir)
  end

  test 'generates empty array for nil' do
    assert_equal [], @generator.generate(nil)
  end

  test 'generates empty array for empty string' do
    assert_equal [], @generator.generate("")
  end

  test 'generates a male name' do
    assert_equal ["DEREK", "LEVI", "PRATICO", "CEDILLO"], @generator.generate("00:00:ca:fe:01:01")
  end

  test 'generates a female name' do
    assert_equal ["KATHY", "ALTA", "ROMEO", "CEDILLO"], @generator.generate("00:01:ca:fe:01:01")
  end

  test 'generates same middle names for single OID' do
    name1 = @generator.generate("24:a4:3c:ec:76:06")
    name2 = @generator.generate("24:a4:3c:e3:d3:92")
    #puts name1.inspect
    #puts name2.inspect
    assert_equal name1[1], name2[1]
    assert_equal name1[2], name2[2]
  end
end
