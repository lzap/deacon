# Foreman Name Generator

Out of ideas for incoming bare-metal host names in your cluster? This little gem is a way out! It contains frequently occurring given names and surnames from the 1990 US Census (public domain data):

* 256 (8 bits) unique male given names
* 256 (8 bits) unique female given names
* 65,536 (16 bits) unique surnames

This gives 33,554,432 (25 bits) total of male and female name combinations. Built-in generator can either generate randomized succession, or generate combinations based on MAC adresses.

Examples of MAC-based names:

* 24:a4:3c:ec:76:06 -> FLOYD MARVIN TOMASSO SORAN
* 24:a4:3c:e3:d3:92 -> ANTONIO MARVIN TOMASSO MOTTET

MAC addresses with same OID part (24:a4:3c in this case) generates the same middle name (MARVIN TOMASSO in the example above), therefore it is possible to guess server (or NIC) vendor from it, or it should be possible to shorten middle names (e.g. FLOYD MT SORAN) in homogeneous environments.

The random name generator makes use of [Fibonacci linear feedback shift register](https://en.wikipedia.org/wiki/Linear_feedback_shift_register) which gives deterministic sequence of pseudo-random numbers. Additionally, algorighm makes sure names with same first name (or gender) and last name are not returned in succession. Since there are about 1% of such cases, there are about 33 million unique total names. During plugin installation, the register is seeded with a random value, so each installation gets unique sequence. Example sequence:

* DORIS RUFENACHT
* EILEEN HYRE
* LLOYD ISKRA
* COREY ANTONETTY
* DORIS COSTINE
* RAMON PALL

The polynomial used in linear feedback shift register is x^25 + x^24 + x^23 + x^22 + 1.

## Installation

See [How_to_Install_a_Plugin](http://projects.theforeman.org/projects/foreman/wiki/How_to_Install_a_Plugin)
for how to install Foreman plugins

## Usage

Go to Global settings to select name generator type and create new host without name in order to have a generated name. Possible types:

* OFF - The feature is turned off.
* MAC+RANDOM - When a host does not have a primary address MAC filled in (e.g. when using virtualization), random name is generated as a fallback mechanism.
* MAC - MAC only generation - hosts without primary MAC address won't get generated name.
* RANDOM - Random only generation.

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

