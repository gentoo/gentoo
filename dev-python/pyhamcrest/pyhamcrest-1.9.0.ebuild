# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

MY_PN="PyHamcrest"

DESCRIPTION="Hamcrest framework for matcher objects"
HOMEPAGE="https://github.com/hamcrest/PyHamcrest"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples test"

RDEPEND=">=dev-python/six-1.4[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-1.2.2[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-2.6[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_PN}-${PV}"

RESTRICT="test"
# the pypi tarball is missing the tests
# and the 1.9.0 tag is missing in GitHub

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_test() {
	py.test -v || die "Tests failed under ${EPYTHON}"
	"${PYTHON}" tests/object_import.py || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html/. )
	use examples && dodoc -r examples

	distutils-r1_python_install_all
}
