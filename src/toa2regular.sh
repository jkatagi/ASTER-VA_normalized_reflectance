#!/bin/sh
# 2016/10/18 Jin Katagi

for scene in `ls original`; do
# Under this, GRASS process
  output_dir=regular/${scene}
  mkdir -p ${output_dir}

  g.region rast=${scene}_vnir1_toa

  # calc
  r.mapcalc "${scene}_sum_toa= ${scene}_vnir1_toa + ${scene}_vnir2_toa + ${scene}_vnir3n_toa"
  r.mapcalc "${scene}_vnir1_regular = if(${scene}_vnir1_toa != 0, ${scene}_vnir1_toa / ${scene}_sum_toa, 0)"
  r.mapcalc "${scene}_vnir2_regular = if(${scene}_vnir2_toa != 0, ${scene}_vnir2_toa / ${scene}_sum_toa, 0)"
  r.mapcalc "${scene}_vnir3n_regular = if(${scene}_vnir3n_toa != 0, ${scene}_vnir3n_toa / ${scene}_sum_toa, 0)"


  r.out.gdal input=${scene}_vnir1_regular  output=${output_dir}/data1.l3a.vnir1.tif
  r.out.gdal input=${scene}_vnir2_regular  output=${output_dir}/data1.l3a.vnir2.tif
  r.out.gdal input=${scene}_vnir3n_regular output=${output_dir}/data1.l3a.vnir3n.tif
done #scene

