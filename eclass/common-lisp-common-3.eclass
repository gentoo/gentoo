# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
#
# Author Matthew Kennedy <mkennedy@gentoo.org>
#
# Sundry code common to many Common Lisp related ebuilds.  Some
# implementation use the Portage time stamp hack to ensure their
# installed files have the right modification time relative to each
# other.

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

# Bug https://bugs.gentoo.org/show_bug.cgi?id=16162 should remove the
# need for this hack.

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
	case ${impl} in
		cmucl|sbcl)
			impl-restore-timestamp-hack ${impl}
			;;
		*)
			;;
	esac
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
