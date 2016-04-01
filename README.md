# [Deacon](https://rubygems.org/gems/deacon) - human readable random name generator

Out of ideas for incoming bare-metal host names in your cluster? This little
gem is a way out! It contains frequently occurring given names and surnames
from the 1990 US Census (public domain data):

* 256 (8 bits) unique male given names
* 256 (8 bits) unique female given names
* 65,536 (16 bits) unique surnames

Given names were filtered to be 3-5 characters long, surnames 5-8 characters,
therefore generated names are never longer than 14 characters (5+1+8).

This gives 33,554,432 (25 bits) total of male and female name combinations.
Built-in generator can either generate randomized succession, or generate
combinations based on MAC adresses.

### Random generator

The random name generator makes use of [Fibonacci linear feedback shift
register](https://en.wikipedia.org/wiki/Linear_feedback_shift_register) which
gives deterministic sequence of pseudo-random numbers. Additionally, algorithm
makes sure names with same first name (or gender) and last name are not
returned in succession. Since there are about 1% of such cases, there are
about 33 million unique total names. Example sequence:

* velma-pratico.my.lan
* angie-warmbrod.my.lan
* grant-goodgine.my.lan
* alton-sieber.my.lan
* velma-vanbeek.my.lan
* don-otero.my.lan
* sam-hulan.my.lan

The polynomial used in linear feedback shift register is

	x^25 + x^24 + x^23 + x^22 + 1.

The key thing is to store register (a number) and use it for each generation
in order to get non-repeating sequence of name combinations. See an example
below.

### MAC generator

Examples of MAC-based names:

* 24:a4:3c:ec:76:06 -> bobby-louie-sancher-weeler.my.lan
* 24:a4:3c:e3:d3:92 -> bob-louie-sancher-rimando.my.lan

MAC addresses with same OID part (24:a4:3c in this case) generates the same
middle name ("Louie Sancher" in the example above), therefore it is possible to
guess server (or NIC) vendor from it, or it should be possible to shorten
middle names (e.g. bobby-ls-weeler.my.lan) in homogeneous environments.

## Comparison of types

MAC-based advantages

* reprovisioning the same server generates the same name
* middle names are same for unique hardware vendors

MAC-based disadvantages

* name is longer

Random-based advantages

* name is shorter

Random-based disadvantages

* reprovisioning the same server generates different name

## Usage

Random LFSR non-repeating generator example:

	require "deacon"
	register = Deacon::RandomGenerator::random_initial_seed
	generator = Deacon::RandomGenerator.new
	(1..5).each do |_|
	  # store the register in non-volatile memory (e.g. on disk)
	  register, firstname, lastname = generator.generate(register)
	  puts firstname + ' ' + lastname
	end

Example output:

	LOREN SPAHN
	JULIO GIMBEL
	CORY SIBILIO
	PATSY CUSSON
	HUGH SHIMER

Random LFSR generator example:

	require "deacon"
	generator = Deacon::RandomGenerator.new
	(1..5).each do |_|
	  # ignoring the register can lead to duplicities!
	  _, firstname, lastname = generator.generate
	  puts firstname + ' ' + lastname
	end

MAC generator example:

	require "deacon"
	generator = Deacon::MacGenerator.new
	firstname, lastname = generator.generate("AA:BB:CC:DD:EE:FF")
	puts firstname + ' ' + lastname

## Contributing

Fork and send a Pull Request. Thanks!

## Copyright

Copyright (c) 2016 Lukas Zapletal

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

