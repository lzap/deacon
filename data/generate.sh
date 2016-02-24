#!/bin/bash
N_8BIT=$((2 ** 8))
N_16BIT=$((2 ** 16))

# Generates seekable text files, each line is N bytes long (including EOL)

# First male names = min length 3, max length 5, N=6
cut -b 1-14 dist.male.first | \
  egrep '^[A-Z]+ {9} *$' | \
  egrep -v '^[A-Z]{2} *$' | \
  cut -b 1-5 | \
  head -n $N_8BIT | \
  sort -R > gmnames.txt

# First male names = min length 3, max length 5, N=6
# (also filters out same male names)
cut -b 1-14 dist.female.first | \
  egrep '^[A-Z]+ {9} *$' | \
  egrep -v '^[A-Z]{2} *$' | \
  cut -b 1-5 | \
  grep -v -f gmnames.txt | \
  head -n $N_8BIT | \
  sort -R > gfnames.txt

# Last names = min length 5, max length 8, N=9
cut -b 1-14 dist.all.last | \
  egrep '^[A-Z]+ {6} *$' | \
  egrep -v '^[A-Z]{2,4} *$' | \
  cut -b 1-8 | \
  head -n $N_16BIT | \
  sort -R > srnames.txt
