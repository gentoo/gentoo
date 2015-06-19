# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-eleeminator/lc-eleeminator-0.6.70.ebuild,v 1.1 2014/08/03 18:50:02 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Embedded LeechCraft Terminal Emulator"

SLOT="0"
KEYWORDS=" ~amd64 ~x86"
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	x11-libs/qtermwidget"
RDEPEND="${DEPEND}"
