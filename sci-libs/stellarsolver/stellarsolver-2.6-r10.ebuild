# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Cross-platform Sextractor and Astrometry.net-Based internal astrometric solver"
HOMEPAGE="https://github.com/rlancaste/stellarsolver"
SRC_URI="https://github.com/rlancaste/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtbase:6[concurrent,gui,network,widgets]
	sci-libs/cfitsio:=
	sci-libs/gsl:=
	sci-astronomy/wcslib:=
"
DEPEND="${RDEPEND}"

src_configure() {
	# bug #862930
	filter-lto

	local mycmakeargs=(
		-DUSE_QT5=OFF
		-DBUILD_CLI=OFF # nothing is installed (yet?)
	)

	cmake_src_configure
}
