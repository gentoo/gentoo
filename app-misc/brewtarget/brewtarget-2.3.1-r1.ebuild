# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="ca cs da de el en es et eu fr gl hu it lv nb nl pl pt ru sr sv tr zh"
inherit cmake plocale

DESCRIPTION="Application to create and manage beer recipes"
HOMEPAGE="http://www.brewtarget.org/"
SRC_URI="https://github.com/Brewtarget/${PN}/releases/download/v${PV}/${PN}_${PV}.orig.tar.xz"

LICENSE="GPL-3 WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="
	dev-qt/linguist-tools:5
"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-no-qtwebkit.patch"
	"${FILESDIR}/${P}-no-compress-docs.patch"
)

remove_locale() {
	sed -i -e "/bt_${1}\.ts/d" CMakeLists.txt || die
}

src_prepare() {
	cmake_src_prepare

	plocale_find_changes translations bt_ .ts
	plocale_for_each_disabled_locale remove_locale

	# Tests are bogus, don't build them
	sed -i -e '/Qt5Test/d' CMakeLists.txt || die
	sed -i -e '/=Tests=/,/=Installs=/d' src/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DDOCDIR="${EPREFIX}"/usr/share/doc/${PF}
		-DDO_RELEASE_BUILD=ON
		-DNO_MESSING_WITH_FLAGS=ON
	)
	cmake_src_configure
}
