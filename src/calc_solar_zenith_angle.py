# -*- coding;utf-8 -*-
import numpy as np
import sys

def calc_solar_zenith_angle(solar_declination, lat, hour_angle):
    lat_radian = np.deg2rad(lat)
    cos = np.sin(solar_declination)*np.sin(lat_radian) + np.cos(solar_declination)*np.cos(lat_radian)*np.cos(hour_angle)
    return np.rad2deg( np.arccos(cos) )

def calc_solar_declination(DOY):
    b1 = 0.006918
    b2 = 0.399912
    b3 = 0.070257
    b4 = 0.006758
    b5 = 0.000907
    b6 = 0.002697
    b7 = 0.001480

    # What if in the case of a leap year?
    A = 2 * np.pi * DOY / 365

    solar_declination = b1 - b2*np.cos(A) + b3*np.sin(A) - b4*np.cos(2*A) + b5*np.sin(2*A) - b6 * np.cos(3*A) + b7*np.sin(3*A)

    return solar_declination


def calc_hour_angle(DOY, GMT, lon):
    a1 = 0.000075
    a2 = 0.001868
    a3 = 0.032077
    a4 = 0.014615
    a5 = 0.040849

    B = 2 * np.pi * DOY / 365.

    ET = (a1 + a2*np.cos(B) - a3*np.sin(B) - a4*np.cos(2*B) - a5*np.sin(2*B))*12 / np.pi
    MST = GMT + lon / 15.

    TST = MST + ET

    t = 15 * (np.pi / 180) *(TST - 12)

    return t


def main():
    solar_declination = calc_solar_declination(DOY)
    hour_angle = calc_hour_angle(DOY, GMT, lon)

    solar_zenith_angle =  calc_solar_zenith_angle(solar_declination, lat, hour_angle)
    print(solar_zenith_angle)

if __name__ == "__main__":
    args = sys.argv
    DOY  = int(args[1]) # ex) 100
    GMT  = float(args[2]) # ex) 2.000
    lat  = float(args[3]) # ex) 35.5
    lon  = float(args[4]) # ex) 136.6667

    main(DOY, GMT, lat, lon)

