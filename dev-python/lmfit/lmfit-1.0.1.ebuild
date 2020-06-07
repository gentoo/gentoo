# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..8} )
inherit distutils-r1

DESCRIPTION="Non-Linear Least-Squares Minimization and Curve-Fitting for Python"
HOMEPAGE="https://lmfit.github.io/lmfit-py/ https://github.com/lmfit/lmfit-py/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="
	>=dev-python/asteval-0.9.16[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.16[${PYTHON_USEDEP}]
	>=dev-python/uncertainties-3.0.1[${PYTHON_USEDEP}]
	>=sci-libs/scipy-1.2[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

distutils_enable_tests pytest
