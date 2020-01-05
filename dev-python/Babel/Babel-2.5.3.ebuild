# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Collection of tools for internationalizing Python applications"
HOMEPAGE="http://babel.pocoo.org/ https://pypi.org/project/Babel/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${DEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# Make the tests use implementation-specific datadir,
	# because they try to write in it.
	sed -e '/datadir =/s:os\.path\.dirname(__file__):os.environ["BUILD_DIR"]:' \
		-i tests/messages/test_frontend.py || die
	sed -e '/^intersphinx_mapping/,+3d' -i docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	# Create implementation-specific datadir for tests.
	cp -R -l tests/messages/data "${BUILD_DIR}"/ || die
	py.test || die
}

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
