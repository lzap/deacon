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
      [0x1000000, 'VELMA', 'PRATICO'],
      [0x17fffff, 'ANGIE', 'WARMBROD'],
      [0x0017fff, 'GRANT', 'GOODGINE'],
      [0x000bfff, 'ALTON', 'SIEBER'],
      [0x100000b, 'VELMA', 'VANBEEK'],
      [0x0800005, 'DON', 'OTERO'],
      [0x0400002, 'SAM', 'HULAN'],
      [0x0200000, 'AARON', 'PRATICO'],
      [0x10fffff, 'SALLY', 'WARMBROD'],
      [0x0087fff, 'TED', 'GOODGINE'],
      [0x0043fff, 'CORY', 'THURSBY'],
      [0x0021fff, 'GARRY', 'HANDREN'],
      [0x0010fff, 'GRANT', 'STELMAN'],
      [0x00087ff, 'ALTON', 'KAWSKI'],
      [0x1000043, 'VELMA', 'MIRRA'],
      [0x1800021, 'SUSAN', 'DARBY'],
      [0x1c00010, 'MARIA', 'BOURDON'],
      [0x1e00007, 'ANNIE', 'SCHMANDT'],
      [0x1f00003, 'MAYRA', 'BURNAUGH'],
      [0x1f80001, 'FAYE', 'ROMEO'],
      [0x1fc0000, 'OPAL', 'PRATICO'],
      [0x1fdffff, 'CLARA', 'WARMBROD'],
      [0x07f7fff, 'DUANE', 'GOODGINE'],
      [0x03fbfff, 'ERVIN', 'SIEBER'],
      [0x01fdfff, 'ELDON', 'LEYUA'],
      [0x00fefff, 'GARY', 'TRASHER'],
      [0x007f7ff, 'BRET', 'ONDRICK'],
      [0x003fbff, 'LANCE', 'BISTER'],
      [0x001fdff, 'GRANT', 'KUZIEL'],
      [0x000feff, 'ALTON', 'THOMPON'],
      [0x10003fb, 'VELMA', 'SWILLE'],
      [0x08001fd, 'DON', 'DEBRECHT'],
      [0x14000fe, 'TARA', 'VAUGHNS'],
      [0x0a0007e, 'HEATH', 'RUSHTON'],
      [0x050003e, 'BRUCE', 'PHEONIX'],
      [0x028001e, 'KURT', 'VEAZEY'],
      [0x014000e, 'DEWEY', 'MOHSENI'],
      [0x00a0006, 'ELI', 'DEWEY'],
      [0x1050002, 'ROSA', 'HULAN'],
      [0x0828000, 'JESUS', 'PONTON'],
      [0x1413fff, 'MABEL', 'THURSBY'],
      [0x0a09fff, 'HEATH', 'ZEHNDER'],
      [0x0504fff, 'BRUCE', 'BARTOLO'],
      [0x02827ff, 'KURT', 'MCCLEE'],
      [0x01413ff, 'DEWEY', 'PASKELL'],
      [0x00a09ff, 'ELI', 'HASFJORD'],
      [0x00504ff, 'KARL', 'ANIBAL'],
      [0x002827f, 'GARRY', 'SHALA'],
      [0x001413f, 'GRANT', 'HIEBER'],
      [0x000a09f, 'ALTON', 'PERIGO'],
    ]
    seq = []
    ix = 1
    (1..50).each do |_|
      ix, first, last = tuple = @generator.generate(ix)
      #puts "[0x#{sprintf("%07x", ix)}, '#{first}', '#{last}'],"
      seq << tuple
    end
    assert_equal expected, seq
  end

  test 'generates a name for the initial round' do
    assert_equal [16777216, "VELMA", "PRATICO"], @generator.generate(1)
  end

  test 'generates a name for the last round' do
    assert_equal [32766, "ALTON", "MCCORY"], @generator.generate((2**25) - 2)
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
