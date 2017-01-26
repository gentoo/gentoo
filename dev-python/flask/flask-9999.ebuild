# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1 git-2

EGIT_REPO_URI="git://github.com/mitsuhiko/flask.git
	https://github.com/mitsuhiko/flask.git"

DESCRIPTION="A microframework based on Werkzeug, Jinja2 and good intentions"
MY_PN="Flask"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"
HOMEPAGE="https://pypi.python.org/pypi/Flask"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="examples test"

RDEPEND="dev-python/blinker[${PYTHON_USEDEP}]
	>=dev-python/itsdangerous-0.21[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.4[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-0.7[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"
#if LIVE
SRC_URI=
KEYWORDS=
#endif

python_test() {
	py.test tests || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
