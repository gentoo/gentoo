# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/ashvardanian/SimSIMD
# TODO: freethreading
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi toolchain-funcs

DESCRIPTION="Fastest SIMD-Accelerated Vector Similarity Functions for x86 and Arm"
HOMEPAGE="
	https://github.com/ashvardanian/SimSIMD/
	https://pypi.org/project/simsimd/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="openmp"

BDEPEND="
	test? (
		dev-python/tabulate[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-repeat )
distutils_enable_tests pytest

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp; then
		tc-check-openmp
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp; then
		tc-check-openmp
	fi
}

src_prepare() {
	sed -i -e '/-O3/d' setup.py || die
	if ! use openmp; then
		sed -i -e '/-fopenmp/d' setup.py || die
	fi

	distutils-r1_src_prepare
}

src_compile() {
	einfo "Please disregard initial compiler errors -- the package is checking"
	einfo "for target support."

	distutils-r1_src_compile
}

python_test() {
	epytest scripts/test.py
}
