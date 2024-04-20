# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Astronomical routines for the Python programming language"
HOMEPAGE="https://rhodesmill.org/pyephem/"
SRC_URI="https://github.com/brandon-rhodes/pyephem/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

BDEPEND="doc? ( dev-python/sphinx )"

PATCHES=(
	"${FILESDIR}"/${P}-clang-15.patch
)

EPYTEST_DESELECT=(
	# Can't find its test files (class not loaded properly in test env?)
	# bug #855461
	tests/test_jpl.py::JPLTest::runTest
)

distutils_enable_tests pytest

src_prepare() {
	# Don't install rst files by default
	sed -i -e "s:'doc/\*\.rst',::" setup.py || die
	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile
	if use doc; then
		PYTHONPATH=. emake -C ephem/doc html
	fi
}

python_test() {
	cd "${T}" || die
	epytest --pyargs ephem
}

src_install() {
	use doc && HTML_DOCS=( ephem/doc/_build/html/. )
	distutils-r1_src_install
}

python_install() {
	distutils-r1_python_install

	rm -r "${D}$(python_get_sitedir)/ephem/tests" || die
}
