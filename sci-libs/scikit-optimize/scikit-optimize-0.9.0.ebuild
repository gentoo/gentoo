# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Sequential model-based optimization library"
HOMEPAGE="https://scikit-optimize.github.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/joblib-0.11[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.13.3[${PYTHON_USEDEP}]
	>=dev-python/scipy-0.19.1[${PYTHON_USEDEP}]
	>=sci-libs/scikit-learn-0.20.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
# No such file or directory: image/logo.png
#distutils_enable_sphinx doc \
#	dev-python/numpydoc \
#	dev-python/sphinx-issues \
#	dev-python/sphinx-gallery
