#!/bin/bash
cat test.pl | iconv -f utf8 -t cp1251 > test_1251.pl
chmod +x ./test_1251.pl
./test_1251.pl 
evince spisak.ps