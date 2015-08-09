# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )
DISTUTILS_IN_SOURCE_BUILD=TRUE

# time
RESTRICT="test"

inherit distutils-r1

DESCRIPTION="A pep8 equivalent for bash scripts"
HOMEPAGE="https://pypi.python.org/pypi/bashate"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-0.8.0[${PYTHON_USEDEP}]
	<dev-python/pbr-1.0[${PYTHON_USEDEP}]
"
RDEPEND="
	>=dev-python/Babel-0.9.6[${PYTHON_USEDEP}]
"

python_install_all() {
	distutils-r1_python_install_all
}
