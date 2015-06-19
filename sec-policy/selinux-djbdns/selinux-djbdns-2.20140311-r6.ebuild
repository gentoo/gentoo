# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-djbdns/selinux-djbdns-2.20140311-r6.ebuild,v 1.2 2014/11/01 17:38:36 swift Exp $
EAPI="5"

IUSE=""
MODS="djbdns"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for djbdns"

KEYWORDS="amd64 x86"
DEPEND="${DEPEND}
	sec-policy/selinux-daemontools
"
RDEPEND="${DEPEND}"
