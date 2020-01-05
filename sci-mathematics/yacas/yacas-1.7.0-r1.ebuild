# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop

DESCRIPTION="General purpose computer algebra system"
HOMEPAGE="http://www.yacas.org/"
SRC_URI="https://codeload.github.com/grzegorzmazur/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
gui? ( https://dev.gentoo.org/~asturm/distfiles/${PN}-bundled-${PV}.tar.xz )"

LICENSE="GPL-2 gui? ( MIT Apache-2.0 OFL-1.1 )"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"
IUSE="gui +jupyter static-libs test"
RESTRICT="!test? ( test )"

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

PATCHES=(
	"${FILESDIR}/${P}-gnuinstalldirs.patch"
	"${FILESDIR}/${P}-desktop.patch"
	"${FILESDIR}/${P}-use-bundled-not-external.patch" # bug 690534
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_CYACAS_BENCHMARKS=OFF
		-DENABLE_DOCS=OFF # requires sphinxcontrib-bibtex
		-DENABLE_JYACAS=OFF # requires manual install
		-DENABLE_CYACAS_GUI=$(usex gui)
		-DENABLE_CYACAS_KERNEL=$(usex jupyter)
		-DENABLE_CYACAS_UNIT_TESTS=$(usex test)
	)
	cmake_src_configure
}
