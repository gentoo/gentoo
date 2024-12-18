# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A high-performance immutable mapping type for Python"
HOMEPAGE="
	https://github.com/MagicStack/immutables/
	https://pypi.org/project/immutables/
"
SRC_URI="
	https://github.com/MagicStack/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="+native-extensions"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/mypy/d' tests/conftest.py || die
	distutils-r1_src_prepare
}

python_compile() {
	# upstream controls NDEBUG explicitly
	use debug && local -x DEBUG_IMMUTABLES=1
	local -x IMMUTABLES_EXT=$(usex native-extensions 1 0)

	distutils-r1_python_compile
}

python_test() {
	local EPYTEST_IGNORE=(
		tests/test_mypy.py
	)

	rm -rf immutables || die
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
