#!/overlay/bin/bash

rm /tmp/lockfile
IMEI='860461020041284'
KEY='466874'
URL="http://updates.opengps.net/"

while : ; do
  if [[ ! -e /tmp/lockfile ]]; then
        touch /tmp/lockfile
        nmea=$(gpspipe -r -n 10 | grep GPGGA)
        utc=$(echo $nmea | cut -d, -f2)
        latitude=$(echo $nmea |  cut -d, -f3)
        CLAT=$(echo $nmea | cut -d, -f4)
        longitude=$(echo $nmea | cut -d, -f5)
        CLON=$(echo $nmea | cut -d, -f6)
        altitude=$(echo $nmea | cut -d, -f11)
        HDOP=$(echo $nmea | cut -d, -f9)
        fix=$(echo $nmea | cut -d, -f7)
        nmea2=$(gpspipe -r -n 18 | grep GPVTG)
        cog=$(echo $nmea2 | cut -d, -f4)
        spkm=$(echo $nmea2  | cut -d, -f8)
        spkn=$(echo $nmea2 | cut -d, -f6)
        nmea3=$(gpspipe -r -n 18 | grep GPRMC)
        date=$(echo $nmea3 | cut -d, -f10)
        nmea4=$(gpspipe -r -n 18 | grep GPGGA)
        nsat=$(echo $nmea4 | cut -d, -f8)
        cont=$(($cont+1))
        base=$(echo ${utc},${latitude}${CLAT},${longitude}${CLON},${HDOP},${altitude},${fix},${cog},${spkm},${spkn},${date},${nsat})
        wget "${URL}index.php?imei=${IMEI}&key=${KEY}&data=${base}" -O /tmp/returnfile >> /dev/null
        rm /tmp/lockfile


  fi
  sleep 10
done

