# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/http-parser/http-parser-0.7.8.ebuild,v 1.5 2013/01/21 11:21:51 ago Exp $

EAPI=4

SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS="2.5 *-jython"

inherit distutils eutils

DESCRIPTION="HTTP request/response parser for python in C"
HOMEPAGE="http://github.com/benoitc/http-parser"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools
	dev-python/cython"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

src_prepare() {
	epatch "${FILESDIR}"/${P}-setup.patch
}

src_install() {
	distutils_src_install
	if use examples; then
		docompress -x usr/share/doc/${P}/examples
		insinto usr/share/doc/${P}
		doins -r examples/
	fi
}
