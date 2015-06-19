# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/common-lisp-common-2.eclass,v 1.5 2012/06/02 19:16:31 zmedico Exp $
#
# Author Matthew Kennedy <mkennedy@gentoo.org>
#
# Sundry code common to many Common Lisp related ebuilds.

# Some handy constants

inherit eutils multilib

CLSOURCEROOT=/usr/share/common-lisp/source/
CLSYSTEMROOT=/usr/share/common-lisp/systems/

# Many of our Common Lisp ebuilds are either inspired by, or actually
# use packages and files from the Debian project's archives.

do-debian-credits() {
	docinto debian
	for i in copyright README.Debian changelog; do
		test -f $i && dodoc "${S}"/debian/${i}
	done
	docinto .
}

# BIG FAT HACK: Since the Portage emerge step kills file timestamp
# information, we need to compensate by ensuring all FASL files are
# more recent than their source files.

# The following `impl-*-timestamp-hack' functions SHOULD NOT be used
# outside of this eclass.

impl-save-timestamp-hack() {
	local impl=$1
	dodir /usr/share/${impl}
	tar cpjf "${D}"/usr/share/${impl}/portage-timestamp-compensate -C "${D}"/usr/$(get_libdir)/${impl} .
}

impl-restore-timestamp-hack() {
	local impl=$1
	tar xjpfo /usr/share/${impl}/portage-timestamp-compensate -C /usr/$(get_libdir)/${impl}
}

impl-remove-timestamp-hack() {
	local impl=$1
	rm -rf /usr/$(get_libdir)/${impl} &>/dev/null || true
}

standard-impl-postinst() {
	local impl=$1
	unregister-common-lisp-implementation cmucl
	case ${impl} in
		cmucl|sbcl)
			impl-restore-timestamp-hack ${impl}
			;;
		*)
			;;
	esac
	register-common-lisp-implementation ${impl}
}

standard-impl-postrm() {
	local impl=$1 impl_binary=$2
	if [ ! -x ${impl_binary} ]; then
		case ${impl} in
			cmucl|sbcl)
				impl-remove-timestamp-hack ${impl}
				;;
			*)
				;;
		esac
		rm -rf /var/cache/common-lisp-controller/*/${impl}
	fi
}

# Local Variables: ***
# mode: shell-script ***
# tab-width: 4 ***
# End: ***
