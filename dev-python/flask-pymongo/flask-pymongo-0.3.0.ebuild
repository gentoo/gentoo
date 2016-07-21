# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Flask-PyMongo"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="PyMongo support for Flask"
HOMEPAGE="https://pypi.python.org/pypi/Flask-PyMongo"
SRC_URI="https://github.com/dcrosta/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
#SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples"
RESTRICT="test"

RDEPEND=">=dev-python/flask-0.8[${PYTHON_USEDEP}]
	>=dev-python/pymongo-2.4[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/docbuild.patch )

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	# fix me
	nosetests tests/{test_url_converter.py,test_wrappers.py} || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
