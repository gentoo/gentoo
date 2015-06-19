# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-vrooby/lc-vrooby-0.6.60.ebuild,v 1.5 2014/08/10 17:59:55 slyfox Exp $

EAPI="5"

inherit leechcraft

DESCRIPTION="Vrooby, removable device manager for LeechCraft"

SLOT="0"
KEYWORDS="amd64 x86"
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
