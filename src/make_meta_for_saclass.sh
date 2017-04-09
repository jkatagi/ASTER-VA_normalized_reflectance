#!/bin/sh
#時間、緯度・軽度、バンドをメタ情報から取得し、作成する

tile=N36E140
ofile_dir=for_saclass/${tile}

mkdir -p ${ofile_dir}
for scene in `ls original`; do
metadata=./original/${scene}/data1.l3a.gh
yyyymmdd=`grep CalendarDate ${metadata}  | sed 's/CalendarDate="\(.*\)";/\1/g'`

yyyy=`echo ${yyyymmdd} | cut -b 1-4`
mm=`echo ${yyyymmdd} | cut -b 5-6`
dd=`echo ${yyyymmdd} | cut -b 7-8`

MIN_LON=`grep WestBoundingRectangle ${metadata} | sed 's/WestBoundingRectangle=\(.*\);/\1/g'`
MAX_LON=`grep EastBoundingRectangle ${metadata} | sed 's/EastBoundingRectangle=\(.*\);/\1/g'`
MIN_LAT=`grep SouthBoundingRectangle ${metadata} | sed 's/SouthBoundingRectangle=\(.*\);/\1/g'`
MAX_LAT=`grep NorthBoundingRectangle ${metadata} | sed 's/NorthBoundingRectangle=\(.*\);/\1/g'`

cat << EOF > for_saclass/N36E140/${scene}.tif.txt
OBS_DATE ${yyyy}/${mm}/${dd}-xx:xx:xx
MIN_LON $MIN_LON
MAX_LON $MAX_LON
MIN_LAT $MIN_LAT
MAX_LAT $MAX_LAT
GAIN_BAND1 1
GAIN_BAND2 1
GAIN_BAND3 1
REF_SLOPE xx
EOF
done
