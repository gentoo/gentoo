# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-dropbox/selinux-dropbox-2.20141203-r7.ebuild,v 1.2 2015/08/04 16:49:40 perfinion Exp $
EAPI="5"

IUSE=""
MODS="dropbox"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for dropbox"

if [[ $PV == 9999* ]] ; then
	KEYWORDS=""
else
	KEYWORDS="amd64 x86"
fi
DEPEND="${DEPEND}
	sec-policy/selinux-xserver
	sec-policy/selinux-dbus
"
RDEPEND="${RDEPEND}
	sec-policy/selinux-xserver
	sec-policy/selinux-dbus
"
