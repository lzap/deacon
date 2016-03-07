require "test_helper"

class MacGeneratorTest < MiniTest::Unit::TestCase
  def setup
    dir = File.expand_path('../../../data', __FILE__)
    @generator = Deacon::MacGenerator.new(dir)
  end

  def test_generates_empty_array_for_nil
    assert_equal [], @generator.generate(nil)
  end

  def test_generates_empty_array_for_empty_string
    assert_equal [], @generator.generate("")
  end

  def test_generates_a_male_name
    assert_equal ["DEREK", "LEVI", "PRATICO", "CEDILLO"], @generator.generate("00:00:ca:fe:01:01")
  end

  def test_generates_a_female_name
    assert_equal ["KATHY", "ALTA", "ROMEO", "CEDILLO"], @generator.generate("00:01:ca:fe:01:01")
  end

  def test_generates_same_middle_names_for_single_oid
    name1 = @generator.generate("24:a4:3c:ec:76:06")
    name2 = @generator.generate("24:a4:3c:e3:d3:92")
    #puts name1.inspect
    #puts name2.inspect
    assert_equal name1[1], name2[1]
    assert_equal name1[2], name2[2]
  end
end
