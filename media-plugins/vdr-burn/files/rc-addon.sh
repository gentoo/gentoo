# $Id$
#
# rc-addon-script for plugin burn
#
# Joerg Bornkessel hd_brummy@gentoo.org

. /etc/conf.d/vdr.burn

: ${BURN_TMPDIR:=/tmp}
: ${BURN_DATADIR:=/var/vdr/video}
: ${BURN_DVDWRITER:=/dev/dvd}
: ${BURN_ISODIR:=/var/vdr/video/dvd-images}

# be shure BURN_ISODIR is available!
make_isodir() {
	if [ ! -e "${BURN_ISODIR}" ]; then
		mkdir "${BURN_ISODIR}"
		touch "${BURN_ISODIR}"/.keep.rc-burn
		chown -R vdr:vdr "${BURN_ISODIR}"
	fi
}

make_isodir

plugin_pre_vdr_start() {

  add_plugin_param "-t ${BURN_TMPDIR}"
  add_plugin_param "-d ${BURN_DATADIR}"
  add_plugin_param "-D ${BURN_DVDWRITER}"
  add_plugin_param "-i ${BURN_ISODIR}"
}

