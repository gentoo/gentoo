# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="+native-extensions"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/mypy/d' tests/conftest.py || die
	# NB: upstream never builds extensions on PyPy
	if ! use native-extensions; then
		sed -i -e '/ext_modules=/d' setup.py || die
	fi
	distutils-r1_src_prepare
}

python_compile() {
	# upstream controls NDEBUG explicitly
	use debug && local -x DEBUG_IMMUTABLES=1
	distutils-r1_python_compile
}

python_test() {
	local EPYTEST_IGNORE=(
		tests/test_mypy.py
	)

	rm -rf immutables || die
	epytest
}
