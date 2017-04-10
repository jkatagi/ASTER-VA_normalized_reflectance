#!/bin/bash
# 2017/04/10 Jin Katagi
# run all process.

# convert DN to radiance.
./dn2radiance.sh

# convert radiance to toa_radiance.
./radiance2toa.sh

# convert toa_radiance to regular_radiance.
./toa2regular.sh


# More steps.
# If you want to use regular_radiance as saclass input,
# you should comment out those two lines. 
# ./make_meta_for_saclass.sh
# ./cut_for_saclass.sh
