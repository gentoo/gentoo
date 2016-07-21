#!/bin/sh

GEOIP_MIRROR="https://geolite.maxmind.com/download/geoip/database"
GEOIPDIR=@PREFIX@/usr/share/GeoIP
TMPDIR=

DATABASES="
	GeoIPv6
	GeoLiteCity
	GeoLiteCityv6-beta/GeoLiteCityv6
	GeoLiteCountry/GeoIP
	asnum/GeoIPASNum
	asnum/GeoIPASNumv6
"

if [ "${1}" = -f ] || [ "${1}" = --force ]; then
	force=true
fi

if [ -d "${GEOIPDIR}" ]; then
	cd $GEOIPDIR
	if [ -n "${DATABASES}" ]; then
		TMPDIR=$(mktemp -d geoipupdate.XXXXXXXXXX)

		echo "Updating GeoIP databases..."

		for db in $DATABASES; do
			fname=$(basename $db)

			if [ -f "${GEOIPDIR}/${fname}.dat" ] || [ ${force} ]; then
				wget --no-verbose -t 3 -T 60 \
					"${GEOIP_MIRROR}/${db}.dat.gz" \
					-O "${TMPDIR}/${fname}.dat.gz"
				if [ $? -eq 0 ]; then
					gunzip -fdc "${TMPDIR}/${fname}.dat.gz" > "${TMPDIR}/${fname}.dat"
					mv "${TMPDIR}/${fname}.dat" "${GEOIPDIR}/${fname}.dat"
					chmod 0644 "${GEOIPDIR}/${fname}.dat"
					case ${fname} in
						GeoLite*) ln -sf ${fname}.dat `echo ${fname} | sed 's/GeoLite/GeoIP/'`.dat ;;
					esac
				fi
			fi
		done
		[ -d "${TMPDIR}" ] && rm -rf $TMPDIR
	fi
fi
