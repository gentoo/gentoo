# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Non-Linear Least-Squares Minimization and Curve-Fitting for Python"
HOMEPAGE="https://lmfit.github.io/lmfit-py/ https://github.com/lmfit/lmfit-py/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-python/asteval-0.9.22[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.18[${PYTHON_USEDEP}]
	>=dev-python/uncertainties-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.4[${PYTHON_USEDEP}]
"
# past from future needed for tests, bug #737978
BDEPEND="
	test? ( dev-python/future[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
