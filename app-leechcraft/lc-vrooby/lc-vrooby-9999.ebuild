# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit leechcraft

DESCRIPTION="Vrooby, removable device manager for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
		dev-qt/qtdbus:4"
RDEPEND="${DEPEND}
		sys-fs/udisks:2"

src_configure() {
	local mycmakeargs=(
		-DENABLE_VROOBY_UDISKS=OFF
		-DENABLE_VROOBY_UDISKS2=ON
		)

	cmake-utils_src_configure
}
