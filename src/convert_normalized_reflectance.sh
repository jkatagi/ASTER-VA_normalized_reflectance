#!/bin/bash
# 2017/04/10 Jin Katagi
# run all process.

# convert DN to radiation.
./dn2radiation.sh

# convert radiation to toa_radiation.
./radiation2toa.sh

# convert toa_radiation to regular_radiation.
./toa2regular.sh


# More steps.
# If you want to use regular_radiation as saclass input,
# you should comment out those two lines. 
# ./make_meta_for_saclass.sh
# ./cut_for_saclass.sh
