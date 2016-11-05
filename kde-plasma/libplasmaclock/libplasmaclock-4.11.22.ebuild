# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kde-workspace"
KMMODULE="libs/plasmaclock"
inherit kde4-meta

DESCRIPTION="Libraries for KDE Plasma's clocks"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug +pim"

DEPEND="
	kde-plasma/kephal:4
	pim? ( $(add_kdeapps_dep kdepimlibs) )
"
RDEPEND="${DEPEND}"

KMSAVELIBS="true"

KMEXTRACTONLY="
	libs/kephal/
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with pim KdepimLibs)
	)

	kde4-meta_src_configure
}
