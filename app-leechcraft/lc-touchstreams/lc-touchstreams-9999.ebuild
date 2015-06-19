# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-touchstreams/lc-touchstreams-9999.ebuild,v 1.2 2013/10/02 08:28:53 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="VKontakte music source plugin for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	>=dev-libs/boost-1.52.0
	dev-libs/qjson
	dev-qt/qtwebkit:4"
RDEPEND="${DEPEND}"
