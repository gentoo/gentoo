# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=scikit-build-core
PYPI_PN=RapidFuzz
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Rapid fuzzy string matching in Python using various string metrics"
HOMEPAGE="
	https://github.com/rapidfuzz/RapidFuzz/
	https://pypi.org/project/RapidFuzz/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

# all these are header-only libraries
DEPEND="
	>=dev-cpp/taskflow-3.0.0
	>=dev-cpp/rapidfuzz-cpp-3.3.2
	dev-python/numpy[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/cython-3[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( hypothesis )
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	# sterilize build flags
	sed -i -e '/CMAKE_INTERPROCEDURAL_OPTIMIZATION/d' CMakeLists.txt || die
	# remove bundled libraries
	rm -r extern || die
	# force recythonization
	find src -name '*.cxx' -delete || die
	# do not require exact taskflow version
	sed -i -e '/Taskflow/s:3\.9\.0::' CMakeLists.txt || die
	# https://github.com/scikit-build/scikit-build-core/issues/912
	sed -i -e '/scikit-build-core/s:0\.11:0.8:' pyproject.toml || die

	distutils-r1_src_prepare

	export RAPIDFUZZ_BUILD_EXTENSION=1
}
