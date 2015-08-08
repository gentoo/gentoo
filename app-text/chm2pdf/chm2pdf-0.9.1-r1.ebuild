# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
PYTHON_DEPEND="2"
inherit python eutils

DESCRIPTION="A script that converts a CHM file into a single PDF file"
HOMEPAGE="http://code.google.com/p/chm2pdf/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE=""

RDEPEND="dev-python/pychm
	app-text/htmldoc
	|| ( >=dev-libs/chmlib-0.40-r1[examples]
		<dev-libs/chmlib-0.40-r1 )"

pkg_setup() {
	python_set_active_version 2
}

src_prepare(){
	epatch "${FILESDIR}/tempdir.patch"
	python_convert_shebangs 2 ${PN}
}

src_install() {
	dobin ${PN} || die "failed to create executable"
	dodoc README || die "dodoc failed"
}
