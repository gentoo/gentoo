# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Flask support for MongoDB and with WTF model forms"
HOMEPAGE="https://pypi.org/project/flask-mongoengine/"
SRC_URI="
	https://github.com/MongoEngine/flask-mongoengine/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"
# TODO: make it spawn a local mongodb instance
RESTRICT="test"

RDEPEND=">=dev-python/flask-1.1.2[${PYTHON_USEDEP}]
	>=dev-python/mongoengine-0.20[${PYTHON_USEDEP}]
	>=dev-python/flask-wtf-0.14.3[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_prepare_all() {
	sed -i -e '/addopts/d' setup.cfg || die

	# fails with mongomock installed
	sed -e 's:test_connection__should_parse_mongo_mock_uri:_&:' \
		-i tests/test_connection.py || die

	distutils-r1_python_prepare_all
}
