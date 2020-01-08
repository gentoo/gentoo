# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Provides functionality for gaming input devices"

HOMEPAGE="https://sourceforge.net/projects/libgaminggear/"
SRC_URI="mirror://sourceforge/libgaminggear/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	>=dev-db/sqlite-3.17:3
	dev-libs/glib:2
	media-libs/libcanberra
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/libnotify
	x11-libs/pango
"

DEPEND="
	${RDEPEND}
	dev-libs/libgudev
	media-libs/harfbuzz
"
BDEPEND="
	dev-util/glib-utils
	doc? ( app-doc/doxygen )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.10.0-doc.patch
	"${FILESDIR}"/${P}-cmake-3.13.patch
)

# Required because xdg.eclass overrides src_prepare() from cmake.eclass
src_prepare() {
	cmake_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr
		-DWITH_DOC="$(usex doc)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
