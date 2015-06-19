# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-gacts/lc-gacts-0.6.60.ebuild,v 1.3 2014/04/03 08:13:22 zlogene Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Allows other LeechCraft modules to register global shortcuts"

SLOT="0"
KEYWORDS="amd64 x86"
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
