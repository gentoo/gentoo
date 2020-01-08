# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit gnome2-utils multilib python-single-r1 qmake-utils xdg-utils

DESCRIPTION="A general purpose tile map editor"
HOMEPAGE="https://www.mapeditor.org/"
SRC_URI="https://github.com/bjorn/tiled/archive/v${PV}/${P}.tar.gz"

LICENSE="BSD BSD-2 GPL-2+"
SLOT="0"
KEYWORDS="amd64"
IUSE="examples python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-qt/qtcore-5.9:5
	>=dev-qt/qtgui-5.9:5
	>=dev-qt/qtnetwork-5.9:5
	>=dev-qt/qtwidgets-5.9:5
	sys-libs/zlib
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

DOCS=( AUTHORS COPYING NEWS.md README.md )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	eqmake5 LIBDIR="/usr/$(get_libdir)" PREFIX="/usr" DISABLE_PYTHON_PLUGIN="$(usex !python)"
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	einstalldocs

	if use examples ; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
