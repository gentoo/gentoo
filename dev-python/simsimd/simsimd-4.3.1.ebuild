# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 toolchain-funcs

MY_P=SimSIMD-${PV}
DESCRIPTION="Fastest SIMD-Accelerated Vector Similarity Functions for x86 and Arm"
HOMEPAGE="
	https://github.com/ashvardanian/SimSIMD/
	https://pypi.org/project/simsimd/
"
# no sdist, as of 4.3.1
# https://github.com/ashvardanian/SimSIMD/issues/113
SRC_URI="
	https://github.com/ashvardanian/SimSIMD/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="openmp"

BDEPEND="
	test? (
		dev-python/pytest-repeat[${PYTHON_USEDEP}]
	)
"

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
	# https://github.com/ashvardanian/SimSIMD/pull/115
	sed -i -e '/-O3/d' -e 's:-lgomp:-fopenmp:' setup.py || die
	if ! use openmp; then
		sed -i -e '/-fopenmp/d' setup.py || die
	fi

	distutils-r1_src_prepare
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p repeat python/test.py
}
