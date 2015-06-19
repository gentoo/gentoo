# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-gacts/lc-gacts-9999.ebuild,v 1.2 2013/12/17 11:13:08 pinkbyte Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Allows other LeechCraft modules to register global shortcuts"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	x11-libs/libqxt"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWITH_GACTS_BUNDLED_QXT=OFF
	)
	cmake-utils_src_configure
}
