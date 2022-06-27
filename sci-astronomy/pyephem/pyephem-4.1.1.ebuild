# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Astronomical routines for the Python programming language"
HOMEPAGE="https://rhodesmill.org/pyephem/"
SRC_URI="https://github.com/brandon-rhodes/pyephem/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

BDEPEND="doc? ( dev-python/sphinx )"

distutils_enable_tests unittest

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
