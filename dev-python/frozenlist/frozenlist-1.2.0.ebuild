# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="A list-like structure which implements collections.abc.MutableSequence"
HOMEPAGE="
	https://pypi.org/project/frozenlist/
	https://github.com/aio-libs/frozenlist/"
SRC_URI="
	https://github.com/aio-libs/frozenlist/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~riscv ~sparc ~x86"

BDEPEND="
	$(python_gen_cond_dep '
		dev-python/cython[${PYTHON_USEDEP}]
	' 'python*')"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/addopts/d' pytest.ini || die
	distutils-r1_src_prepare
}

python_configure() {
	# pypy is not using the C extension
	if [[ ${EPYTHON} == python* ]]; then
		> .install-cython || die
		emake cythonize
	fi
}
