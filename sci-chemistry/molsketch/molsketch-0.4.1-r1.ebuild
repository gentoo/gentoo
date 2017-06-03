# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MAKEFILE_GENERATOR=ninja

inherit cmake-utils multilib qmake-utils

MY_P=${P/m/M}-src

DESCRIPTION="A drawing tool for 2D molecular structures"
HOMEPAGE="http://molsketch.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/Molsketch/Beryllium-7%20${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="
	>=sci-chemistry/openbabel-2.2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P%%-src}

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.0-_DEFAULT_SOURCE.patch
	"${FILESDIR}"/${P}-more-quotes.patch
	)

src_prepare() {
	sed -e "/LIBRARY DESTINATION/ s/lib/$(get_libdir)/g" \
		-i {obabeliface,libmolsketch/src}/CMakeLists.txt || die #351246
	sed -e "s:doc/molsketch:doc/${PF}:g" \
		-i molsketch/src/{CMakeLists.txt,mainwindow.cpp} || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DOPENBABEL2_INCLUDE_DIR="${EPREFIX}/usr/include/openbabel-2.0"
		-DCMAKE_DISABLE_FIND_PACKAGE_KDE4=ON
		-DENABLE_TESTS=$(usex test "ON" "OFF")
		-DMSK_INSTALL_PREFIX=/usr
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dosym ${PN}-qt5 /usr/bin/${PN}
}
