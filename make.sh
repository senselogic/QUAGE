#!/bin/sh
set -x
dmd -m64 quage.d
rm *.o
