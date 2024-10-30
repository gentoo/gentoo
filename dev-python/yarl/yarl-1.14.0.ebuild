# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Yet another URL library"
HOMEPAGE="
	https://github.com/aio-libs/yarl/
	https://pypi.org/project/yarl/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="+native-extensions"

RDEPEND="
	>=dev-python/idna-2.0[${PYTHON_USEDEP}]
	>=dev-python/multidict-4.0[${PYTHON_USEDEP}]
	>=dev-python/propcache-0.2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	native-extensions? (
		dev-python/cython[${PYTHON_USEDEP}]
	)
	dev-python/expandvars[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_compile() {
	local -x YARL_NO_EXTENSIONS=0
	if ! use native-extensions || [[ ${EPYTHON} != python* ]]; then
		YARL_NO_EXTENSIONS=1
	fi
	distutils-r1_python_compile
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local opts=()
	# note different boolean logic than for backend (sigh)
	local -x YARL_NO_EXTENSIONS=
	if ! use native-extensions || [[ ${EPYTHON} != python* ]]; then
		YARL_NO_EXTENSIONS=1
	fi

	rm -rf yarl || die
	epytest -o addopts= "${opts[@]}"
}
