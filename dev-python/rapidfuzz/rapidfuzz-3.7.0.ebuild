# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
# custom wrapper over setuptools
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 multiprocessing pypi

DESCRIPTION="Rapid fuzzy string matching in Python using various string metrics"
HOMEPAGE="
	https://github.com/rapidfuzz/RapidFuzz/
	https://pypi.org/project/rapidfuzz/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

# all these are header-only libraries
DEPEND="
	>=dev-cpp/taskflow-3.0.0
	>=dev-cpp/rapidfuzz-cpp-3.0.2
	dev-python/numpy[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/cython-3[${PYTHON_USEDEP}]
	dev-python/rapidfuzz-capi[${PYTHON_USEDEP}]
	>=dev-python/scikit-build-0.16.2[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# sterilize build flags
	sed -i -e '/CMAKE_INTERPROCEDURAL_OPTIMIZATION/d' CMakeLists.txt || die
	# remove bundled libraries
	rm -r extern || die
	# force recythonization
	find src -name '*.cxx' -delete || die

	distutils-r1_src_prepare

	export RAPIDFUZZ_BUILD_EXTENSION=1
}

python_compile() {
	distutils-r1_python_compile

	# scikit-build is broken and reuses the same build
	# https://github.com/scikit-build/scikit-build/issues/633
	rm -r _skbuild || die
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p xdist -n "$(makeopts_jobs)" --dist=worksteal
}
