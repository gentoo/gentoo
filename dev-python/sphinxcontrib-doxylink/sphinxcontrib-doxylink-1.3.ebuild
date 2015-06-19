# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sphinxcontrib-doxylink/sphinxcontrib-doxylink-1.3.ebuild,v 1.2 2014/12/08 13:20:14 aballier Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Extension to link to external Doxygen API documentation"
HOMEPAGE="https://pypi.python.org/pypi/sphinxcontrib-doxylink https://pythonhosted.org/sphinxcontrib-doxylink/ https://bitbucket.org/birkenfeld/sphinx-contrib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm"

RDEPEND="
	>=dev-python/sphinx-1.0[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

src_prepare() {
	# any better idea ?
	rm -rf tests
	distutils-r1_src_prepare
}
