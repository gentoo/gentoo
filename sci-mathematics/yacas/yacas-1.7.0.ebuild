# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="General purpose computer algebra system"
HOMEPAGE="http://www.yacas.org/"
SRC_URI="https://codeload.github.com/grzegorzmazur/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"
IUSE="gui +jupyter static-libs test"

DEPEND="
	gui? (
		dev-qt/qtcore:5[icu]
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtopengl:5
		dev-qt/qtprintsupport:5
		dev-qt/qtsql:5
		dev-qt/qtsvg:5
		dev-qt/qtwebengine:5[widgets]
		dev-qt/qtwidgets:5
	)
	jupyter? (
		dev-libs/boost:=
		dev-libs/jsoncpp:=
		dev-libs/openssl:0=
		dev-python/jupyter
		net-libs/zeromq
		>=net-libs/zmqpp-4.1.2
	)
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-gnuinstalldirs.patch" )

src_configure() {
	local mycmakeargs=(
		-DENABLE_CYACAS_BENCHMARKS=OFF
		-DENABLE_DOCS=OFF # requires sphinxcontrib-bibtex
		-DENABLE_JYACAS=OFF # requires manual install
		-DENABLE_CYACAS_GUI=$(usex gui)
		-DENABLE_CYACAS_KERNEL=$(usex jupyter)
		-DENABLE_CYACAS_UNIT_TESTS=$(usex test)
	)
	cmake-utils_src_configure
}
