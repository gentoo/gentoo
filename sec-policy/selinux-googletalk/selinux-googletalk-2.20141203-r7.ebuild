# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-googletalk/selinux-googletalk-2.20141203-r7.ebuild,v 1.1 2015/07/02 17:59:35 perfinion Exp $
EAPI="5"

IUSE="alsa"
MODS="googletalk"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for googletalk"

if [[ $PV == 9999* ]] ; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
