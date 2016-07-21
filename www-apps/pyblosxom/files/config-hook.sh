#!/bin/bash

case "$1" in
    install)
	chown ${VHOST_SERVER_UID} ${MY_INSTALLDIR}/log
	sed -i -e "s#/path/to/blog#${MY_INSTALLDIR}/data/#" ${VHOST_CGIBINDIR}/pyblosxom/config.py || exit
	sed -i -e "s#/path/to/logdir#${MY_INSTALLDIR}/log/#" ${VHOST_CGIBINDIR}/pyblosxom/config.py || exit
	sed -i -e "s#^\#\(.*\)/path/to/my/plugins#\1/usr/share/pyblosxom-1.2.1/plugins/#" ${VHOST_CGIBINDIR}/pyblosxom/config.py || exit
	;;
    *)
	# Nothing to do for clean up
	;;
esac
