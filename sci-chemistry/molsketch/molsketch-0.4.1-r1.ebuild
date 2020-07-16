# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake qmake-utils xdg-utils

DESCRIPTION="A drawing tool for 2D molecular structures"
HOMEPAGE="http://molsketch.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/Molsketch/Beryllium-7%20${PV}/${P^}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	>=sci-chemistry/openbabel-2.2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P^}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.0-_DEFAULT_SOURCE.patch
	"${FILESDIR}"/${P}-more-quotes.patch
)

src_prepare() {
	sed -e "/LIBRARY DESTINATION/ s/lib/$(get_libdir)/g" \
		-i {obabeliface,libmolsketch/src}/CMakeLists.txt || die #351246
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DOPENBABEL2_INCLUDE_DIR="${EPREFIX}"/usr/include/openbabel-2.0
		-DMSK_INSTALL_PREFIX=/usr
		-DMSK_INSTALL_DOCS="${EPREFIX}"/usr/share/doc/${PF}
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dosym ${PN}-qt5 /usr/bin/${PN}
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
