#!/bin/sh
# 2016/10/18 Jin Katagi
# convert radiation to TOA radiation using below equation
# rho_TOA = pi * L * d^2 / (E_sun * cos(theta))
# This script need calc_solar_zenith_angle.py


# set mean solar exoatmospheric irradiances
# We use Smith's E_sun values
e_sun_band1=1845.99
e_sun_band2=1555.74
e_sun_band3n=1119.47

pi=3.14159

for scene in `ls original`; do
# get DOY from metadata
  metadata=./original/${scene}/data1.l3a.gh
  yyyymmdd=`grep CalendarDate ${metadata}  | sed 's/CalendarDate="\(.*\)";/\1/g'`
  doy=`date -d "${yyyymmdd}" '+%j'`

# calc gmt from metadata
  HHMMSS=`grep TimeofDay ${metadata} | sed 's/TimeofDay="\(.*\)Z";/\1/g'`
  HH=`echo ${HHMMSS} | cut -b 1-2`
  MM=`echo ${HHMMSS} | cut -b 3-4 | awk '{print $1/60.0}'`
  SS=`echo ${HHMMSS} | cut -b 5-6 | awk '{print $1/3600.0}'`
  gmt=`echo $HH + $MM +$SS | bc`

# get latitude and longitude from scene.
# We use minimum lat &  minumu lon in this case. (Maybe it is better to use mean lat & lon.)
  lon=`grep WestBoundingRectangle ${metadata} | sed 's/WestBoundingRectangle=\(.*\);/\1/g'`
  lat=`grep SouthBoundingRectangle ${metadata} | sed 's/SouthBoundingRectangle=\(.*\);/\1/g'`

# calculate theta (deg)
  theta=`python calc_solar_zenith_angle.py ${doy} ${gmt} ${lat} ${lon}`

 # calculate d^2
  d_2=`echo ${doy} | awk 'BEGIN{pi=3.14159}{d_2=(1 / (1 + 0.033 * cos(2 * pi * $1/365))); print d_2}'`


# Under this, GRASS process
  output_dir=toa/${scene}
  mkdir -p ${output_dir}

  g.region rast=${scene}_vnir1_radiation

  # check arguments
  echo "doy: ${doy}, gmt: ${gmt}"
  echo "lon: ${lon}, lat: ${lat}"
  echo "theta: ${theta}, d^2: ${d_2}"
  # calc toa
  r.mapcalc "${scene}_vnir1_toa = if(${scene}_vnir1_radiation != 0, ${pi} * ${scene}_vnir1_radiation  * ${d_2} / (${e_sun_band1} * cos(${theta})), 0)"
  r.mapcalc "${scene}_vnir2_toa = if(${scene}_vnir2_radiation != 0, ${pi} * ${scene}_vnir2_radiation  * ${d_2} / (${e_sun_band2} * cos(${theta})), 0)"
  r.mapcalc "${scene}_vnir3n_toa= if(${scene}_vnir3n_radiation != 0, ${pi} * ${scene}_vnir3n_radiation  * ${d_2} / (${e_sun_band3n} * cos(${theta})), 0)"


  r.out.gdal input=${scene}_vnir1_toa output=${output_dir}/data1.l3a.vnir1.tif
  r.out.gdal input=${scene}_vnir2_toa output=${output_dir}/data1.l3a.vnir2.tif
  r.out.gdal input=${scene}_vnir3n_toa output=${output_dir}/data1.l3a.vnir3n.tif
done #scene

