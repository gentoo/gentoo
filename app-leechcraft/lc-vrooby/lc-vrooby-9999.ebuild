# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="Vrooby, removable device manager for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5[widgets]
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}
	sys-fs/udisks:2"

src_configure() {
	local mycmakeargs=(
		-DENABLE_VROOBY_UDISKS=OFF
		-DENABLE_VROOBY_UDISKS2=ON
	)
	cmake_src_configure
}
