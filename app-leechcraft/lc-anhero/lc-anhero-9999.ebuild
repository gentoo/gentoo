# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-anhero/lc-anhero-9999.ebuild,v 1.3 2014/08/10 17:54:13 slyfox Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="AnHero, crash handler for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}
	sys-devel/gdb
"
