# $Id$
#
# rc-addon-script for plugin osdteletext
#
# Joerg Bornkessel <hd_brummy@gentoo.org>
# Matthias Schwarzott <zzam@gentoo.org>

: ${OSDTELETEXT_TMPFS:=yes}
: ${OSDTELETEXT_SIZE:=20}
: ${OSDTELETEXT_DIR:=/var/cache/vdr/osdteletext}
: ${OSDTELETEXT_STORETOPTEXT:=no}

# depends on QA, create paths in /var/cache on the fly at runtime as needed
init_cache_dir() {
	if [ ! -d "${OSDTELETEXT_DIR}" ]; then
		mkdir -p ${OSDTELETEXT_DIR}
		chown vdr:vdr ${OSDTELETEXT_DIR}
	fi
}

plugin_pre_vdr_start() {
	init_cache_dir

	add_plugin_param "-d ${OSDTELETEXT_DIR}"
	add_plugin_param "-n ${OSDTELETEXT_SIZE}"

	if [ "${OSDTELETEXT_STORETOPTEXT}" = "yes" ]; then
		add_plugin_param "-t"
	fi

	if [ "${OSDTELETEXT_TMPFS}" = "yes" ]; then
		## test on mountet TMPFS
		if /bin/mount | /bin/grep -q ${OSDTELETEXT_DIR} ; then
			:
		else
			einfo_level2 mounting videotext dir ${OSDTELETEXT_DIR}
			sudo /bin/mount -t tmpfs -o size=${OSDTELETEXT_SIZE}m,uid=vdr,gid=vdr tmpfs ${OSDTELETEXT_DIR}
		fi
	fi
}

plugin_post_vdr_stop() {
	if [ "${OSDTELETEXT_TMPFS}" = "yes" ]; then
		if /bin/mount | /bin/grep -q ${OSDTELETEXT_DIR} ; then
			einfo_level2 unmounting videotext dir ${OSDTELETEXT_DIR}
			sudo /bin/umount ${OSDTELETEXT_DIR}
		fi
	fi
}
