# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{11..14} python3_{13,14}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Accelerated property cache"
HOMEPAGE="
	https://github.com/aio-libs/propcache/
	https://pypi.org/project/propcache/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="+native-extensions"

BDEPEND="
	native-extensions? (
		dev-python/cython[${PYTHON_USEDEP}]
	)
	dev-python/expandvars[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_compile() {
	local -x PROPCACHE_NO_EXTENSIONS=0
	if ! use native-extensions || [[ ${EPYTHON} != python* ]]; then
		PROPCACHE_NO_EXTENSIONS=1
	fi
	distutils-r1_python_compile
}

python_test() {
	local EPYTEST_IGNORE=(
		tests/test_benchmarks.py
	)

	local opts=()
	if ! use native-extensions || [[ ${EPYTHON} != python* ]]; then
		opts+=( --no-c-extensions )
	fi

	rm -rf propcache || die
	epytest -o addopts= "${opts[@]}"
}
