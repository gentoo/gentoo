# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
inherit distutils-r1

DESCRIPTION="Python module to parse ds9 region file"
HOMEPAGE="http://pyregion.readthedocs.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="MIT"

IUSE="examples"
RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]"
DEPEND="${DEPEND}
	|| ( dev-python/cython[${PYTHON_USEDEP}]
		 dev-python/pyrex[${PYTHON_USEDEP}] )"

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
