# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=scikit-build-core
PYTHON_COMPAT=( python3_{10..13} )

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
KEYWORDS="~alpha amd64 arm arm64 ppc ppc64 ~riscv ~s390 ~sparc x86"

DEPEND="
	<dev-cpp/rapidfuzz-cpp-4
	>=dev-cpp/rapidfuzz-cpp-3.0.0
"
RDEPEND="
	<dev-python/rapidfuzz-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/rapidfuzz-3.9.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/cython-3.0.11[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	# sterilize build flags
	sed -i -e '/CMAKE_INTERPROCEDURAL_OPTIMIZATION/d' CMakeLists.txt || die

	distutils-r1_src_prepare
}
