# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit fdo-mime multilib python-single-r1 qt4-r2

DESCRIPTION="A general purpose tile map editor"
HOMEPAGE="http://www.mapeditor.org/"
SRC_URI="https://github.com/bjorn/tiled/archive/v${PV}/${P}.tar.gz"

LICENSE="BSD-2 GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND=">=dev-qt/qtcore-4.7:4
	>=dev-qt/qtgui-4.7:4
	>=dev-qt/qtopengl-4.7:4
	sys-libs/zlib
	python? ( ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS COPYING NEWS README.md )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	rm -r src/zlib || die
}

src_configure() {
	eqmake4 LIBDIR="/usr/$(get_libdir)" PREFIX="/usr" DISABLE_PYTHON_PLUGIN="$(usex !python)"
}

src_install() {
	qt4-r2_src_install

	if use examples ; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
