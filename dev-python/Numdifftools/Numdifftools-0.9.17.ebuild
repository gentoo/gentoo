# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

MY_PN=numdifftools
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Solves automatic numerical differentiation problems in one or more variables"
HOMEPAGE="https://pypi.org/project/Numdifftools/ https://github.com/pbrod/numdifftools"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.zip"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/algopy-0.4[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.9.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=sci-libs/scipy-0.8[${PYTHON_USEDEP}]
	"
DEPEND="
	>=dev-python/setuptools-0.9[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/pyscaffold[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}"/${MY_P}

python_prepare_all() {
	# pulls coverage test
	sed \
		-e '/tests_require/d' \
		-i setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
