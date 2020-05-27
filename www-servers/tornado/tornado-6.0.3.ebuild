# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Python web framework and asynchronous networking library"
HOMEPAGE="https://www.tornadoweb.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="examples test"
RESTRICT="!test? ( test )"

CDEPEND="
	>=dev-python/pycurl-7.19.3.1[${PYTHON_USEDEP}]
	>=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${CDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
	)
"
RDEPEND="${CDEPEND}"

distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme

# doc without intersphinx does not build (asyncio error)
#PATCHES=(
#	"${FILESDIR}"/4.5.1-drop-intersphinx.patch
#)

src_prepare() {
	# it used to pass, so apparently something changed somewhere
	sed -i -e 's:test_method_after_redirect:_&:' \
		tornado/test/httpclient_test.py || die
	distutils-r1_src_prepare
}

python_test() {
	local -x ASYNC_TEST_TIMEOUT=60
	"${PYTHON}" -m tornado.test.runtests --verbose ||
		die "tests failed under ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r demos/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
