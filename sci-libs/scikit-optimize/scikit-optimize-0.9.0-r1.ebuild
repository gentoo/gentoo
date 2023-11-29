# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1 pypi

DESCRIPTION="Sequential model-based optimization library"
HOMEPAGE="https://scikit-optimize.github.io/"

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

PATCHES=(
	# https://github.com/scikit-optimize/scikit-optimize/pull/1187
	"${FILESDIR}/${P}-numpy-1.24.patch"
	# https://github.com/scikit-optimize/scikit-optimize/pull/1184/files
	"${FILESDIR}/${P}-scikit-learn-1.2.0.patch"
)

distutils_enable_tests pytest
# No such file or directory: image/logo.png
#distutils_enable_sphinx doc \
#	dev-python/numpydoc \
#	dev-python/sphinx-issues \
#	dev-python/sphinx-gallery
