# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="DNS toolkit for Python"
HOMEPAGE="http://www.dnspython.org/ https://pypi.org/project/dnspython/"
SRC_URI="https://github.com/rthalley/dnspython/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="examples"

RDEPEND="dev-python/pycryptodome[${PYTHON_USEDEP}]
	>=dev-python/ecdsa-0.13[${PYTHON_USEDEP}]
	>=dev-python/idna-2.1[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/typing[${PYTHON_USEDEP}]' -2)
	!dev-python/dnspython:py2
	!dev-python/dnspython:py3"

src_prepare() {
	sed -i -e '/network_avail/s:True:False:' \
		tests/test_resolver.py || die
	distutils-r1_src_prepare
}

python_test() {
	pushd tests >/dev/null || die
	"${EPYTHON}" utest.py || die "tests failed under ${EPYTHON}"
	popd > /dev/null || die
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
