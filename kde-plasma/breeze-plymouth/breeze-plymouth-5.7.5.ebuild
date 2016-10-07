# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_AUTODEPS="false"
inherit kde5

DESCRIPTION="Breeze theme for Plymouth"
LICENSE="GPL-2+ GPL-3+"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="sys-boot/plymouth"
DEPEND="${RDEPEND}
	$(add_frameworks_dep extra-cmake-modules)
"

src_configure() {
	local mycmakeargs=(
		-DDISTRO_NAME="Gentoo Linux"
		-DDISTRO_VERSION=
	)

	kde5_src_configure
}
