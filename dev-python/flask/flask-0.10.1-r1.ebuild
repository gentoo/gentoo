# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/flask/flask-0.10.1-r1.ebuild,v 1.12 2015/05/15 12:50:30 blueness Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="A microframework based on Werkzeug, Jinja2 and good intentions"
MY_PN="Flask"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"
HOMEPAGE="https://github.com/mitsuhiko/flask/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="dev-python/blinker[${PYTHON_USEDEP}]
	>=dev-python/itsdangerous-0.21[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.4[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-0.7[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
# Usual; test phase
DISTUTILS_IN_SOURCE_BUILD=1

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${P}-is_package.patch
		"${FILESDIR}"/${P}-sort_json.patch
		"${FILESDIR}"/${P}-test_appcontext.patch )

python_test() {
	"${PYTHON}" run-tests.py || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
