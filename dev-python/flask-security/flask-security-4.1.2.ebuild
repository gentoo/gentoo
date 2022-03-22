# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Simple security for Flask apps"
HOMEPAGE="
	https://github.com/Flask-Middleware/flask-security/
	https://pypi.org/project/Flask-Security-Too/"
SRC_URI="
	https://github.com/Flask-Middleware/flask-security/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-python/blinker-1.4[${PYTHON_USEDEP}]
	dev-python/cachetools[${PYTHON_USEDEP}]
	>=dev-python/flask-1.1.1[${PYTHON_USEDEP}]
	>=dev-python/flask-babelex-0.9.3[${PYTHON_USEDEP}]
	>=dev-python/flask-login-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/flask-principal-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/flask-wtf-0.14.3[${PYTHON_USEDEP}]
	>=dev-python/itsdangerous-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/passlib-1.7.2[${PYTHON_USEDEP}]
	>=dev-python/python-email-validator-1.1.1[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/Babel[${PYTHON_USEDEP}]
	test? (
		>=dev-python/argon2-cffi-19.1.0[${PYTHON_USEDEP}]
		>=dev-python/bcrypt-3.1.5[${PYTHON_USEDEP}]
		dev-python/bleach[${PYTHON_USEDEP}]
		>=dev-python/cryptography-2.3.1[${PYTHON_USEDEP}]
		>=dev-python/flask-mail-0.9.1[${PYTHON_USEDEP}]
		>=dev-python/flask-sqlalchemy-2.3[${PYTHON_USEDEP}]
		>=dev-python/mongomock-3.19.0[${PYTHON_USEDEP}]
		>=dev-python/peewee-3.11.2[${PYTHON_USEDEP}]
		>=dev-python/phonenumbers-8.11.1[${PYTHON_USEDEP}]
		>=dev-python/psycopg-2.8.4:2[${PYTHON_USEDEP}]
		>=dev-python/pymysql-0.9.3[${PYTHON_USEDEP}]
		>=dev-python/pyqrcode-1.2[${PYTHON_USEDEP}]
		>=dev-python/zxcvbn-4.4.28[${PYTHON_USEDEP}]
		>=dev-python/pony-0.7.11[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's@--cache-clear@-p no:httpbin@' pytest.ini || die
	distutils-r1_src_prepare
}

python_configure_all() {
	esetup.py compile_catalog
}
