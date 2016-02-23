module ForemanNameGenerator
  class RandomGenerator < Generator
    MASK = 0x1ffffff

    # Fibonacci linear feedback shift register with x^25 + x^24 + x^23 + x^22 + 1 poly
    def next_lfsr25(seed)
      i = 1
      i = (seed + 1) & MASK
      raise ArgumentError, "Seed #{seed} out of bounds" if seed && i == 0
      i = (seed + 1) & MASK while i == 0
      i = (i >> 1) | ((i[0]^i[1]^i[2]^i[3]) << 0x18)
      i = (i >> 1) | ((i[0]^i[1]^i[2]^i[3]) << 0x18) while i > MASK
      i - 1
    end

    def generate(seed = Time.now.utc.to_i)
      return [] if seed.nil? || seed == 0
      index = seed
      loop do
        index = next_lfsr25(index)
        break if unique?(seed, index)
      end
      given_file = (index & 0x1000000) == 0 ? GIVEN_MALE_NAMES_FILE : GIVEN_FEMALE_NAMES_FILE
      givenname_ix = (index & 0xff0000) >> 16
      surnname_ix = index & 0xffff
      firstname = find_name(givenname_ix, data_file(given_file))
      surname = find_name(surnname_ix, data_file(SURNAMES_FILE))
      [index, firstname, surname]
    end

    def self.random_initial_seed
      rand(MASK - 2) + 1
    end

    private

    # is first (or gender) and last name different from the old value?
    def unique?(ix1, ix2)
      (((ix1 & 0xff0000) != (ix2 & 0xff0000)) || ((ix1 & 0x1000000) != (ix2 & 0x1000000))) && ((ix1 & 0xffff) != (ix2 & 0xffff))
    end
  end
end
