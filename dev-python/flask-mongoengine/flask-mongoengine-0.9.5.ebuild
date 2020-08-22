# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

DESCRIPTION="Flask support for MongoDB and with WTF model forms"
HOMEPAGE="https://pypi.org/project/flask-mongoengine/"
SRC_URI="
	https://github.com/MongoEngine/flask-mongoengine/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
# TODO: make it spawn a local mongodb instance
RESTRICT="test"

RDEPEND=">=dev-python/flask-0.8[${PYTHON_USEDEP}]
	>=dev-python/mongoengine-0.7.10[${PYTHON_USEDEP}]
	dev-python/flask-wtf[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs
distutils_enable_tests nose

python_prepare_all() {
	sed -i -e '/test_requirements/d' setup.py || die
	sed -i -e '/rednose/d' setup.cfg || die

	# TODO: investigate; new pymongo, wtforms?
	sed -e 's:test_connection_default:_&:' \
		-i tests/test_basic_app.py || die
	sed -e 's:test_unique_with:_&:' \
		-i tests/test_forms.py || die
	sed -e 's:test_mongomock:_&:' \
		-i tests/test_connection.py || die

	distutils-r1_python_prepare_all
}
