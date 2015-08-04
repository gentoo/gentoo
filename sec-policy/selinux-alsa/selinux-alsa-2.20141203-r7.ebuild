# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-alsa/selinux-alsa-2.20141203-r7.ebuild,v 1.2 2015/08/04 16:49:35 perfinion Exp $
EAPI="5"

IUSE=""
MODS="alsa"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for alsa"

if [[ $PV == 9999* ]] ; then
	KEYWORDS=""
else
	KEYWORDS="amd64 x86"
fi
