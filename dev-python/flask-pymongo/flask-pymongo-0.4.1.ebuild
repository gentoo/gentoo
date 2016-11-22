# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="PyMongo support for Flask"
HOMEPAGE="https://pypi.python.org/pypi/Flask-PyMongo"
SRC_URI="https://github.com/dcrosta/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RESTRICT="test"
# Testsuite appears to require a running local instance of a pymongo server

RDEPEND=">=dev-python/flask-0.8[${PYTHON_USEDEP}]
	>=dev-python/pymongo-2.4[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/docbuild.patch )

python_prepare_all() {
	# Req'd to avoid file collisions
	sed -e s":find_packages():find_packages(exclude=['tests']):" -i setup.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
