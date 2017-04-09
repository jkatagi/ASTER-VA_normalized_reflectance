#!/bin/sh
# 2016/10/18 Jin Katagi
# convert DN to radiation using below equation
# L = (DN - 1) * a
# L: radiation
# DN: DN
# a : Unit Conversion Coefficients
# band1 -> 0.676000, band2 -> 0.708000, band3n -> 0.862000

# set unit conversion coefficints to variables
band1_unit_coefficients=0.676000
band2_unit_coefficients=0.708000
band3_unit_coefficients=0.862000
for scene in `ls original`; do
  output_dir=radiation/${scene}
  mkdir -p ${output_dir}
  # load tif to grass
  r.in.gdal input=original/${scene}/data1.l3a.vnir1.tif output=${scene}_vnir1
  r.in.gdal input=original/${scene}/data1.l3a.vnir2.tif output=${scene}_vnir2
  r.in.gdal input=original/${scene}/data1.l3a.vnir3n.tif output=${scene}_vnir3n

  g.region rast=${scene}_vnir1

  # calc radiation
  # set 0 and 255 to valu 0 (255 is cloud and 0 is null)
  r.mapcalc "${scene}_vnir1_radiation=if(${scene}_vnir1 != 0 && ${scene}_vnir1 != 255 , (${scene}_vnir1 - 1) * ${band1_unit_coefficients},0)"
  r.mapcalc "${scene}_vnir2_radiation=if(${scene}_vnir2 != 0 && ${scene}_vnir2 != 255 , (${scene}_vnir2 - 1) * ${band2_unit_coefficients},0)"
  r.mapcalc "${scene}_vnir3n_radiation=if(${scene}_vnir3n != 0 && ${scene}_vnir3n != 255 , (${scene}_vnir3n - 1)* ${band3_unit_coefficients},0)"


  r.out.gdal input=${scene}_vnir1_radiation output=${output_dir}/data1.l3a.vnir1.tif
  r.out.gdal input=${scene}_vnir2_radiation output=${output_dir}/data1.l3a.vnir2.tif
  r.out.gdal input=${scene}_vnir3n_radiation output=${output_dir}/data1.l3a.vnir3n.tif
done #scene

