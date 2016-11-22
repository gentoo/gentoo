# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

MY_PN=numdifftools
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Solves automatic numerical differentiation problems in one or more variables"
HOMEPAGE="https://pypi.python.org/pypi/Numdifftools https://github.com/pbrod/numdifftools"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.zip"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

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
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)"

# Seems to be broken
# https://github.com/pbrod/numdifftools/issues/11
# https://github.com/pbrod/numdifftools/issues/12
RESTRICT="test"

S="${WORKDIR}"/${MY_P}

python_prepare_all() {
	sed \
		-e "/numpydoc/d" \
		-i requirements.txt || die
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
