# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="A list-like structure which implements collections.abc.MutableSequence"
HOMEPAGE="
	https://pypi.org/project/frozenlist/
	https://github.com/aio-libs/frozenlist/
"
SRC_URI="
	https://github.com/aio-libs/frozenlist/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="+native-extensions"

BDEPEND="
	native-extensions? (
		$(python_gen_cond_dep '
			dev-python/cython[${PYTHON_USEDEP}]
		' 'python*')
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/addopts/d' pytest.ini || die
	distutils-r1_src_prepare
}

python_compile() {
	# pypy is not using the C extension
	if use native-extensions && [[ ${EPYTHON} == python* ]]; then
		> .install-cython || die
		emake cythonize
	else
		local -x FROZENLIST_NO_EXTENSIONS=1
	fi

	distutils-r1_python_compile
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	rm -rf frozenlist || die
	epytest
}
