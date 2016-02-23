require 'test_plugin_helper'

class RandomGeneratorTest < ActiveSupport::TestCase
  # number of test iterations for some tests
  TEST_ITERATIONS=10_000

  setup do
    @dir = File.expand_path('../../../data', __FILE__)
    @generator = ForemanNameGenerator::RandomGenerator.new(@dir)
    @random = rand((2 ** 25) - (TEST_ITERATIONS+3))
  end

  test 'generates empty array for nil' do
    assert_equal [], @generator.generate(nil)
  end

  test 'generates a deterministic sequence' do
    expected = [
      [0x1000000, 'DORIS', 'RUFENACHT'],
      [0x17fffff, 'EILEEN', 'HYRE'],
      [0x0017fff, 'LLOYD', 'ISKRA'],
      [0x000bfff, 'COREY', 'ANTONETTY'],
      [0x100000b, 'DORIS', 'COSTINE'],
      [0x0800005, 'RAMON', 'PALL'],
      [0x0400002, 'DWAYNE', 'VERVILLE'],
      [0x0200000, 'PHILIP', 'RUFENACHT'],
      [0x10fffff, 'LINDA', 'HYRE'],
      [0x0087fff, 'CLINTON', 'ISKRA'],
      [0x0043fff, 'GABRIEL', 'DOLBERRY'],
      [0x0021fff, 'JAVIER', 'CANTWELL'],
      [0x0010fff, 'LLOYD', 'GRAMLING'],
      [0x00087ff, 'COREY', 'MENDIOLA'],
      [0x1000043, 'DORIS', 'JAHDE'],
      [0x1800021, 'CAROLYN', 'HELSER'],
      [0x1c00010, 'NICOLE', 'RINGEISEN'],
      [0x1e00007, 'TONYA', 'SHEPARDSON'],
      [0x1f00003, 'SHARON', 'AHN'],
      [0x1f80001, 'RITA', 'KLEMAN'],
      [0x1fc0000, 'BARBARA', 'RUFENACHT'],
      [0x1fdffff, 'LAURA', 'HYRE'],
      [0x07f7fff, 'JOSEPH', 'ISKRA'],
      [0x03fbfff, 'ALVIN', 'ANTONETTY'],
      [0x01fdfff, 'TODD', 'SCHIFFELBEIN'],
      [0x00fefff, 'TROY', 'LUECHTEFELD'],
      [0x007f7ff, 'GENE', 'VENABLE'],
      [0x003fbff, 'DEREK', 'RAFANIELLO'],
      [0x001fdff, 'LLOYD', 'ALBARRAN'],
      [0x000feff, 'COREY', 'NAJI'],
      [0x10003fb, 'DORIS', 'CAMFERDAM'],
      [0x08001fd, 'RAMON', 'SUGHROUE'],
      [0x14000fe, 'ELLEN', 'MERIWETHER'],
      [0x0a0007e, 'MICHEAL', 'RENNELS'],
      [0x050003e, 'ERIC', 'SCHOPP'],
      [0x028001e, 'ROGER', 'SCHOFELL'],
      [0x014000e, 'GREG', 'RARDON'],
      [0x00a0006, 'GLEN', 'ERKELA'],
      [0x1050002, 'LUCILLE', 'VERVILLE'],
      [0x0828000, 'BENJAMIN', 'SHARTRAND'],
      [0x1413fff, 'ASHLEY', 'DOLBERRY'],
      [0x0a09fff, 'MICHEAL', 'HULEN'],
      [0x0504fff, 'ERIC', 'PROWELL'],
      [0x02827ff, 'ROGER', 'LOGEMANN'],
      [0x01413ff, 'GREG', 'TOBIASSEN'],
      [0x00a09ff, 'GLEN', 'MOGAVERO'],
      [0x00504ff, 'JIM', 'SAUR'],
      [0x002827f, 'JAVIER', 'FALKENBERG'],
      [0x001413f, 'LLOYD', 'KOLLER'],
      [0x000a09f, 'COREY', 'WORK'],
    ]
    seq = []
    ix = 1
    (1..50).each do |_|
      ix, first, last = tuple = @generator.generate(ix)
      #puts "[0x#{ix.to_s(16)}, '#{first}', '#{last}'],"
      seq << tuple
    end
    assert_equal expected, seq
  end

  test 'generates a name for the initial round' do
    assert_equal [16777216, "DORIS", "RUFENACHT"], @generator.generate(1)
  end

  test 'generates a name for the last round' do
    assert_equal [32766, "COREY", "MAGNI"], @generator.generate((2**25) - 2)
  end

  test 'generates a name for each value in a sequence' do
    @random.step(@random + TEST_ITERATIONS, 1) do |i|
      @generator.generate(i)
    end
  end

  test 'generates non-repeating index sequence' do
    test_hash = {}
    ix = 1
    @random.step(@random + TEST_ITERATIONS, 1) do |i|
      ix = @generator.next_lfsr25(ix)
      if test_hash.include? ix
        fail("Found duplicated index #{ix} (iteration #{i})")
      else
        test_hash[ix] = 1
      end
    end
  end

  test 'never generates two same names' do
    test_hash = {}
    ix = old_ix = 1
    @random.step(@random + TEST_ITERATIONS, 1) do |i|
      ix, first, last = @generator.generate(ix)
      hash = first + last
      if test_hash.include? hash
        fail("Found duplicated name #{fn} #{sn} index #{old_ix}->#{ix} (iteration #{i})")
      else
        test_hash[hash] = 1
      end
      old_ix = ix
    end
  end
end
