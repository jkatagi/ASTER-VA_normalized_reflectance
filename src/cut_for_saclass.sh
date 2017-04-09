#!/bin/sh

tile=N36E140
ofile_dir=for_saclass/${tile}
mkdir -p ${ofile_dir}
mkdir -p regular
mkdir -p merge

size=8000
for scene in `ls original`; do

# merge three band
    gdal_merge.py -separate -o  merge/${scene}.tif -ot Float32 regular/${scene}/*.tif

#cut

    gdalwarp -t_srs EPSG:4326 -te 140 36 141 37 -ts ${size} ${size} ./merge/${scene}.tif ${ofile_dir}/${scene}.tif
done
