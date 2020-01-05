# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} )
DISTUTILS_IN_SOURCE_BUILD=TRUE

# time
RESTRICT="test"

inherit distutils-r1

DESCRIPTION="A pep8 equivalent for bash scripts"
HOMEPAGE="https://pypi.org/project/bashate/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0
"
RDEPEND="
	>=dev-python/Babel-2.3.4[${PYTHON_USEDEP}]
	!~dev-python/Babel-2.4.0
"

python_install_all() {
	distutils-r1_python_install_all
}
