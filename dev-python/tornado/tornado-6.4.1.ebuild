# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )
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
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"
IUSE="test"
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

PATCHES=(
	"${FILESDIR}/${PN}-6.3.2-test-timeout-increase.patch"
	"${FILESDIR}/${PN}-6.3.2-ignore-deprecationwarning.patch"
)

src_prepare() {
	# network-sandbox? ipv6?
	sed -i -e 's:test_localhost:_&:' \
		tornado/test/netutil_test.py || die

	distutils-r1_src_prepare
}

python_test() {
	local -x ASYNC_TEST_TIMEOUT=60
	# Avoid time-sensitive tests
	# https://github.com/tornadoweb/tornado/blob/10974e6ebee80a26a2a65bb9bd715cf858fafde5/tornado/test/util.py#L19
	local -x TRAVIS=1
	local -x NO_NETWORK=1

	cd "${T}" || die
	"${EPYTHON}" -m tornado.test.runtests --verbose ||
		die "tests failed under ${EPYTHON}"
}
