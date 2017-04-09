# ASTER-VA_normalized_reflectance

Convert ASTER-VA products as normalized reflectance.

# Requirements.

* GRASS GIS 7.X (6.X not supported)
* Python
* numpy

# How to use.

## 1, Download from MADAS.
https://gbank.gsj.jp/madas/map/index.htm://gbank.gsj.jp/madas/map/index.html

## 2, Extract files and move to the original directory.
```
$ make original
$ for file in `ls *.tar.bz2`; do bzip2 -dc ${file} | tar xvf -; mv ${file} original done
```

## 3, run.
```
$ cd src
$ chmod +x *.sh *.py
$ ./convert_normalized_reflectance.sh
```
Other script will be called by ./convert_normalized_reflectance.sh .

# More details.

## (i) convert DN to  L_λ (spectral radiance) ($ ./dn2radiance.sh).

```
L_λ =  ( DN - 1) * UCC
```

where UCC : Unit Conversion Coefficient (W/m2/sr/um).

UCC got from this site (p.43) :https://unit.aist.go.jp/igg/rs-rg/ASTERSciWeb_AIST/jp/documnts/users_guide/part1/pdf/Part2_5.1J.pdf

## (ii) convert L_λ  to ρ_TOA,λ (TOA radiation) ($ ./radiance2toa.sh).

```
ρ_TOA,λ = π * L_λ * d^2 / (E_sun,λ * cos(θs))
```

where ρ_TOA,λ:TOA radiation, d:Earth-Sun distance, E_sun,λ:Mean solar exoatmospheric irradiances, θs:Solar zenith angle (deg).


d^2 calced from this equation:
```
d^2 = (1 / (1+0.033 * cos (2π*DOY/365)))
```

refelence:https://unit.aist.go.jp/igg/rs-rg/ASTERSciWeb_AIST/jp/documnts/users_guide/part1/pdf/Part2_5.1J.pdf

### (iii) ρ_TOA,λ → r_i (normalized reflectance) (./toa2regular.sh) 

```
r_i = (ρ_TOA,λ) /( (1/n) * Σ ρ_TOA,λ)
```

where n is number of band (in this case, n=3)

