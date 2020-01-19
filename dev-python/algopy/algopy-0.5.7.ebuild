# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6,3_7} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Taylor Arithmetic Computation and Algorithmic Differentiation"
HOMEPAGE="https://pypi.org/project/algopy/ https://pythonhosted.org/algopy/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	app-arch/unzip
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

python_test() {
	${EPYTHON} run_tests.py || die "Tests fail with ${EPYTHON}"
}
