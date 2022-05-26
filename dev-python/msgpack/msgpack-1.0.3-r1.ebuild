# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="MessagePack (de)serializer for Python"
HOMEPAGE="
	https://msgpack.org/
	https://github.com/msgpack/msgpack-python/
	https://pypi.org/project/msgpack/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~x64-macos"
IUSE="+native-extensions"

# extension code is relying on CPython implementation details
BDEPEND="
	native-extensions? (
		$(python_gen_cond_dep '>=dev-python/cython-0.16[${PYTHON_USEDEP}]' 'python*')
	)
	test? (
		dev-python/six[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# Remove pre-generated cython files
	rm msgpack/_cmsgpack.cpp || die

	if ! use native-extensions ; then
		sed -i -e "/have_cython/s:True:False:" setup.py || die
	fi

	distutils-r1_python_prepare_all
}
