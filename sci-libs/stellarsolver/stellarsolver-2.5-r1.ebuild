# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Cross-platform Sextractor and Astrometry.net-Based internal astrometric solver"
HOMEPAGE="https://github.com/rlancaste/stellarsolver"
SRC_URI="https://github.com/rlancaste/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	sci-libs/cfitsio:=
	sci-libs/gsl:=
	sci-astronomy/wcslib:=
"
DEPEND="${RDEPEND}"

# https://github.com/rlancaste/stellarsolver/issues/108
PATCHES=( "${FILESDIR}"/${P}-{qsort,compiler}-warning.patch ) # git master

src_configure() {
	# bug #862930
	filter-lto

	cmake_src_configure
}
