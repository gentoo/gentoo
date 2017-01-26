# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

MY_PN="Flask-Security"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simple security for Flask apps"
HOMEPAGE="http://pythonhosted.org/Flask-Security/ https://pypi.python.org/pypi/Flask-Security"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
# tests are foobar
RESTRICT="test"

RDEPEND=">=dev-python/flask-0.9[${PYTHON_USEDEP}]
	>=dev-python/itsdangerous-0.17[${PYTHON_USEDEP}]
	>=dev-python/passlib-1.6.1[${PYTHON_USEDEP}]
	>=dev-python/flask-login-0.1.3[${PYTHON_USEDEP}]
	>=dev-python/flask-mail-0.7.3[${PYTHON_USEDEP}]
	>=dev-python/flask-wtf-0.8[${PYTHON_USEDEP}]
	>=dev-python/flask-principal-0.3.3[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/flask-sqlalchemy[${PYTHON_USEDEP}]
		dev-python/flask-mongoengine[${PYTHON_USEDEP}]
		dev-python/bcrypt[${PYTHON_USEDEP}]
		dev-python/simplejson[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/flask-peewee[${PYTHON_USEDEP}]' 'python2*')
	)"

S="${WORKDIR}/${MY_P}"

python_test() {
	nosetests -v || die "Testing failed with ${EPYTHON}"
}
