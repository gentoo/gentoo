# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=scikit-build-core

inherit distutils-r1 pypi

DESCRIPTION="CPU kernels and compiled extensions for Awkward Array"
HOMEPAGE="
	https://github.com/scikit-hep/awkward/
	https://pypi.org/project/awkward-cpp/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-python/numpy-1.18.0[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-python/pybind11[${PYTHON_USEDEP}]
"

src_prepare() {
	default
	# https://github.com/scikit-build/scikit-build-core/issues/912
	sed -i -e '/scikit-build-core/s:0\.10:0.8:' pyproject.toml || die
}

distutils_enable_tests pytest
