# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit fdo-mime gnome2-utils multilib python-single-r1 qmake-utils

DESCRIPTION="A general purpose tile map editor"
HOMEPAGE="http://www.mapeditor.org/"
SRC_URI="https://github.com/bjorn/tiled/archive/v${PV}/${P}.tar.gz"

LICENSE="BSD BSD-2 GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	sys-libs/zlib
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	eqmake5 LIBDIR="/usr/$(get_libdir)" PREFIX="/usr" DISABLE_PYTHON_PLUGIN="$(usex !python)"
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	dodoc AUTHORS COPYING NEWS README.md

	if use examples ; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
