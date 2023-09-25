# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Non-Linear Least-Squares Minimization and Curve-Fitting for Python"
HOMEPAGE="
	https://lmfit.github.io/lmfit-py/
	https://github.com/lmfit/lmfit-py/
	https://pypi.org/project/lmfit/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/asteval-0.9.28[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.19[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.6[${PYTHON_USEDEP}]
	>=dev-python/uncertainties-3.1.4[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-scm-6.2[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	epytest -o addopts=
}
