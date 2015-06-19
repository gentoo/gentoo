# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-kinotify/lc-kinotify-9999.ebuild,v 1.1 2013/03/08 21:59:02 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Fancy visual notifications for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
		>=dev-qt/qtwebkit-4.6:4"
RDEPEND="${DEPEND}"
