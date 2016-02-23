#!/bin/bash
N_8BIT=$((2 ** 8))
N_16BIT=$((2 ** 16))

# Generates seekable text files, each line is 14 bytes long + EOL (15 bytes)
cut -b 1-14 dist.female.first | head -n $N_8BIT | sort -R > gfnames.txt
cut -b 1-14 dist.male.first | grep -v -f gfnames.txt | head -n $N_8BIT | sort -R > gmnames.txt
cut -b 1-14 dist.all.last | head -n $N_16BIT | sort -R > srnames.txt
