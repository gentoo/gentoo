# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Python web framework and asynchronous networking library"
HOMEPAGE="https://www.tornadoweb.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/pycurl-7.19.3.1[${PYTHON_USEDEP}]
	>=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
	)
"

distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme \
	dev-python/sphinxcontrib-asyncio

python_prepare_all() {
	# Disable deprecation-warnings-as-errors because tornado has a lot of stuff deprecated in 3.10
	sed 's/warnings.filterwarnings("error", category=DeprecationWarning, module=r"tornado\\..*")//' \
		-i tornado/test/runtests.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local -x ASYNC_TEST_TIMEOUT=60
	cd "${BUILD_DIR}/lib" || die
	"${PYTHON}" -m tornado.test.runtests --verbose ||
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
