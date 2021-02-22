# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Command line interface for Blosc compression"
HOMEPAGE="https://github.com/Blosc/bloscpack"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

# needs porting to newer numpy, bug #732790
RESTRICT="test"

RDEPEND="
	dev-python/blosc[${PYTHON_USEDEP}]
	dev-python/deprecated[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/nose[${PYTHON_USEDEP}] )"

distutils_enable_tests nose

python_test() {
	PYTHONPATH="${BUILD_DIR}"/lib nosetests -v || die
}
