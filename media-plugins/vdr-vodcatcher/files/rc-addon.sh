# $Id$
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
