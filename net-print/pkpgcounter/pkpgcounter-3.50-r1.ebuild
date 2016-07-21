# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"

inherit distutils

DESCRIPTION="pkpgcounter is a python generic PDL (Page Description Language) parser"
HOMEPAGE="http://www.pykota.com/software/pkpgcounter"
SRC_URI="http://www.pykota.com/software/${PN}/download/tarballs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pillow"
RDEPEND="${DEPEND}"

DOCS="BUGS CREDITS NEWS README PKG-INFO"
PYTHON_MODNAME="pkpgpdls"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	distutils_src_install

	rm -rf "${D}usr/share/doc/${PN}"
}
