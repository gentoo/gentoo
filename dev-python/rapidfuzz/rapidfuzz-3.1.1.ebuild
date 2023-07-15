# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
# custom wrapper over setuptools
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Rapid fuzzy string matching in Python using various string metrics"
HOMEPAGE="
	https://github.com/maxbachmann/RapidFuzz/
	https://pypi.org/project/rapidfuzz/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~mips ~ppc ppc64 ~riscv ~s390 sparc x86"

# all these are header-only libraries
DEPEND="
	>=dev-cpp/taskflow-3.0.0
	>=dev-cpp/rapidfuzz-cpp-2.0.0
	dev-python/numpy[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/rapidfuzz_capi[${PYTHON_USEDEP}]
	>=dev-python/scikit-build-0.16.2[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# sterilize build flags
	sed -i -e '/CMAKE_INTERPROCEDURAL_OPTIMIZATION/d' CMakeLists.txt || die
	# remove bundled libraries
	rm -r extern || die

	distutils-r1_src_prepare

	export RAPIDFUZZ_BUILD_EXTENSION=1
}
