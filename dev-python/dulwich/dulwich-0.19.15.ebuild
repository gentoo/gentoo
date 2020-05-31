# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7,8}} )

inherit distutils-r1

DESCRIPTION="Pure-Python implementation of the Git file formats and protocols"
HOMEPAGE="https://github.com/jelmer/dulwich/ https://pypi.org/project/dulwich/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.23[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		!hppa? ( !ia64? (
			dev-python/gevent[${PYTHON_USEDEP}]
			dev-python/geventhttpclient[${PYTHON_USEDEP}]
		) )
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/python-fastimport[${PYTHON_USEDEP}]
	)"

DISTUTILS_IN_SOURCE_BUILD=1

# One test sometimes fails
# https://github.com/jelmer/dulwich/issues/541
PATCHES=( "${FILESDIR}/${PN}-0.18.3-skip-failing-test.patch" )

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	# Do not use make check which rebuilds the extension and uses -Werror,
	# causing unexpected failures.
	"${EPYTHON}" -m unittest -v dulwich.tests.test_suite \
		|| die "tests failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}
