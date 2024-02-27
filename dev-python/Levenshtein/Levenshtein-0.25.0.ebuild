# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
# custom wrapper over setuptools
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Functions for fast computation of Levenshtein distance, and edit operations"
HOMEPAGE="
	https://pypi.org/project/Levenshtein/
	https://github.com/rapidfuzz/Levenshtein/
"
SRC_URI="
	https://github.com/rapidfuzz/Levenshtein/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~mips ~ppc ppc64 ~riscv ~s390 sparc x86"

DEPEND="
	<dev-cpp/rapidfuzz-cpp-4
	>=dev-cpp/rapidfuzz-cpp-3.0.0
"
RDEPEND="
	<dev-python/rapidfuzz-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/rapidfuzz-3.1.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/cython-3.0.2[${PYTHON_USEDEP}]
	>=dev-python/scikit-build-0.13.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	# sterilize build flags
	sed -i -e '/CMAKE_INTERPROCEDURAL_OPTIMIZATION/d' CMakeLists.txt || die

	distutils-r1_src_prepare
}
