# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
