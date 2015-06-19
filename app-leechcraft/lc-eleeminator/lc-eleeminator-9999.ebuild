# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-eleeminator/lc-eleeminator-9999.ebuild,v 1.1 2014/05/20 17:04:26 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Embedded LeechCraft Terminal Emulator"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	x11-libs/qtermwidget"
RDEPEND="${DEPEND}"
