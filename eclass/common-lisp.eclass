# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/common-lisp.eclass,v 1.14 2011/12/27 17:55:12 fauli Exp $
#
# Author Matthew Kennedy <mkennedy@gentoo.org>
#
# This eclass supports the common-lisp-controller installation of many
# Common Lisp libraries

inherit common-lisp-common

CLPACKAGE=
DEPEND="dev-lisp/common-lisp-controller"

EXPORT_FUNCTIONS pkg_preinst pkg_postinst pkg_postrm

common-lisp_pkg_postinst() {
	if [ -z "${CLPACKAGE}" ]; then
		die "CLPACKAGE was empty or undefined upon call to pkg_prerm"
	else
		for package in ${CLPACKAGE}; do
			einfo "Registering Common Lisp source for ${package}"
			register-common-lisp-source ${package}
		done
	fi
}

common-lisp_pkg_postrm() {
	if [ -z "${CLPACKAGE}" ]; then
		die "CLPACKAGE was empty or undefined upon call to pkg_prerm"
	else
		for package in ${CLPACKAGE}; do
			if [ ! -d ${CLSOURCEROOT}/${package} ]; then
				einfo "Unregistering Common Lisp source for ${package}"
#				rm -rf ${CLFASLROOT}/*/${package}
				unregister-common-lisp-source ${package}
			fi
		done
	fi
}

#
# In pkg_preinst, we remove the FASL files for the previous version of
# the source.
#
common-lisp_pkg_preinst() {
	if [ -z "${CLPACKAGE}" ]; then
		die "CLPACKAGE was empty or undefined upon call to pkg_preinst"
	else
		for package in ${CLPACKAGE}; do
			einfo "Removing FASL files for previous version of Common Lisp package ${package}"
			rm -rf ${CLFASLROOT}/*/${package} || true
		done
	fi
}

common-lisp-install() {
	insinto ${CLSOURCEROOT}/${CLPACKAGE}
	doins $@
}

common-lisp-system-symlink() {
	dodir ${CLSYSTEMROOT}/`dirname ${CLPACKAGE}`
	if [ $# -eq 0 ]; then
		dosym ${CLSOURCEROOT}/${CLPACKAGE}/${CLPACKAGE}.asd \
			${CLSYSTEMROOT}/${CLPACKAGE}.asd
	else
		for package in "$@" ; do
			dosym ${CLSOURCEROOT}/$CLPACKAGE/${package}.asd \
				${CLSYSTEMROOT}/${package}.asd
		done
	fi
}

# Local Variables: ***
# mode: shell-script ***
# tab-width: 4 ***
# End: ***
