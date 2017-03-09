# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit leechcraft

DESCRIPTION="Vrooby, removable device manager for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtwidgets:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5[widgets]
"
RDEPEND="${DEPEND}
	sys-fs/udisks:2"

mycmakeargs=(
	-DENABLE_VROOBY_UDISKS=OFF
	-DENABLE_VROOBY_UDISKS2=ON
	)
