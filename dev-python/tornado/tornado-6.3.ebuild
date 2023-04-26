# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="Python web framework and asynchronous networking library"
HOMEPAGE="
	https://www.tornadoweb.org/
	https://github.com/tornadoweb/tornado/
	https://pypi.org/project/tornado/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		$(python_gen_cond_dep '
			>=dev-python/pycurl-7.19.3.1[${PYTHON_USEDEP}]
		' 'python*')
	)
"

src_prepare() {
	# network-sandbox? ipv6?
	sed -i -e 's:test_localhost:_&:' \
		tornado/test/netutil_test.py || die

	distutils-r1_src_prepare
}

python_test() {
	local -x ASYNC_TEST_TIMEOUT=60
	cd "${T}" || die
	"${EPYTHON}" -m tornado.test.runtests --verbose ||
		die "tests failed under ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r demos/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
