# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

MY_PN="Flask-WTF"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simple integration of Flask and WTForms"
HOMEPAGE="https://pythonhosted.org/Flask-WTF/ https://pypi.org/project/Flask-WTF/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/Babel[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-babel[${PYTHON_USEDEP}]
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	>=dev-python/wtforms-1.0.5[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_prepare_all() {
	# tries to access things over the network
	rm tests/test_recaptcha.py || die
	distutils-r1_python_prepare_all
}
