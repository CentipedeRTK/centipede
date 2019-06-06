#!/usr/bin/python
#https://github.com/navdata-net/meta-navdatanet/blob/rocko/recipes-setup/gnss-station/files/ecef2llh.py

import sys
import math

def spherical_ecef_to_lla3D(ecefArr):

    x = float(ecefArr[0])
    y = float(ecefArr[1])
    z = float(ecefArr[2])

    a = 6378137;
    e = 8.1819190842622e-2;

    asq = math.pow(a,2);
    esq = math.pow(e,2);

    b   = math.sqrt(asq * (1 - esq) );
    bsq = math.pow(b, 2);

    ep  = math.sqrt((asq - bsq)/bsq);
    p   = math.sqrt(math.pow(x, 2) + math.pow(y, 2) );
    th  = math.atan2(a * z, b * p);

    lon = math.atan2(y, x);
    lat = math.atan2( (z + math.pow(ep, 2) * b * math.pow(math.sin(th), 3)), (p - esq * a * math.pow(math.cos(th), 3)) );
    N = a / ( math.sqrt(1 - esq * math.pow(math.sin(lat), 2)) );
    alt = p / math.cos(lat) - N; 

    lon = lon * 180 / math.pi;
    lat = lat * 180 / math.pi;
    s   =  repr(lat)+';'+ repr(lon)
    print s

spherical_ecef_to_lla3D(sys.argv[1:4])
