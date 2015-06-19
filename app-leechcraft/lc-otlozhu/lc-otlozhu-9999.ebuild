# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-otlozhu/lc-otlozhu-9999.ebuild,v 1.2 2013/07/20 20:25:20 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Otlozhu, a GTD-inspired ToDo manager plugin for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	~app-leechcraft/liblaretz-${PV}
	>=dev-qt/qtgui-4.8:4"
RDEPEND="${DEPEND}"
