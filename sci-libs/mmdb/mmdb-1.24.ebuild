# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools-utils

DESCRIPTION="The Coordinate Library, designed to assist CCP4 developers in working with coordinate files"
HOMEPAGE="http://launchpad.net/mmdb/"
SRC_URI="
	http://www.ysbl.york.ac.uk/~emsley/software/${P}.tar.gz
	http://launchpad.net/mmdb/1.23/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="static-libs"

DEPEND="!<sci-libs/ccp4-libs-6.1.3"
RDEPEND=""

src_install() {
	autotools-utils_src_install

	# create missing mmdb.pc
	cat >> "${T}"/mmdb.pc <<- EOF
	prefix=${EPREFIX}/usr
	exec_prefix=${EPREFIX}/usr
	libdir=${EPREFIX}/usr/$(get_libdir)
	includedir=${EPREFIX}/usr/include/mmdb

	Name: ${PN}
	Description: Macromolecular coordinate library
	Version: ${PV}
	Requires:
	Conflicts:
	Libs: -L${EPREFIX}/usr/$(get_libdir) -lmmdb
	Cflags: -I${EPREFIX}/usr/include/mmdb

	EOF

	insinto /usr/$(get_libdir)/pkgconfig
	doins "${T}"/mmdb.pc
}
