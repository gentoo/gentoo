# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit leechcraft

DESCRIPTION="The taskbar quark for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	x11-libs/libXcomposite
	dev-qt/qtwidgets:5
	dev-qt/qtdeclarative:5
"
RDEPEND="${DEPEND}
	 ~virtual/leechcraft-quark-sideprovider-${PV}"
