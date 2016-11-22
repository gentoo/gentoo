# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="A script that converts a CHM file into a single PDF file"
HOMEPAGE="https://code.google.com/p/chm2pdf/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE=""

RDEPEND="dev-python/pychm[${PYTHON_USEDEP}]
	app-text/htmldoc
	>=dev-libs/chmlib-0.40-r1[examples]
	${PYTHON_DEPS}"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

PATCHES=( "${FILESDIR}/tempdir.patch" )

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare(){
	python_fix_shebang .
}

src_install() {
	default
	python_doscript ${PN} || die "failed to create executable"
}
