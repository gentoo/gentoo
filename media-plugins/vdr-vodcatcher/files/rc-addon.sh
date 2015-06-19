# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-vodcatcher/files/rc-addon.sh,v 1.1 2014/06/22 11:05:30 hd_brummy Exp $
#
# rc-addon-script for plugin vodcatcher
#
# Joerg Bornkessel <hd_brummy@gentoo.org>

VODCATCHER_CACHE_DIR=var/cache/vdr-plugin-vodcatcher

# depends on QA, create paths in /var/cache on the fly at runtime as needed
init_cache_dir() {
    if [ ! -d "${VODCATCHER_CACHE_DIR}" ]; then
        mkdir -p ${VODCATCHER_CACHE_DIR}
        chown vdr:vdr ${VODCATCHER_CACHE_DIR}
    fi
}
