# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-spamassassin/selinux-spamassassin-9999.ebuild,v 1.4 2015/03/22 13:47:30 swift Exp $
EAPI="5"

IUSE=""
MODS="spamassassin"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for spamassassin"

if [[ $PV == 9999* ]] ; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
