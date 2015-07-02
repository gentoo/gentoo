# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-clamav/selinux-clamav-2.20141203-r6.ebuild,v 1.2 2015/07/02 18:07:03 perfinion Exp $
EAPI="5"

IUSE=""
MODS="clamav"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for clamav"

if [[ $PV == 9999* ]] ; then
	KEYWORDS=""
else
	KEYWORDS="amd64 x86"
fi
