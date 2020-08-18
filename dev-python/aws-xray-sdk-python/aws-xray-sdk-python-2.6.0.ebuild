# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="AWS X-Ray SDK for Python"
HOMEPAGE="https://github.com/aws/aws-xray-sdk-python https://pypi.org/project/aws-xray-sdk/"
SRC_URI="
	https://github.com/aws/aws-xray-sdk-python/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=dev-python/botocore-1.12.122[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/jsonpickle[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/bottle[${PYTHON_USEDEP}]
		dev-python/flask-sqlalchemy[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest-aiohttp[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

src_prepare() {
	# unpackaged deps
	rm -r tests/ext/{aiobotocore,django,pg8000,psycopg2,pymysql,pynamodb} || die

	# TODO
	sed -i -e 's:test_external:_&:' tests/test_patcher.py || die
	# require Internet access
	rm tests/ext/aiohttp/test_client.py || die
	rm -r tests/ext/{httplib,requests} || die

	distutils-r1_src_prepare
}

src_test() {
	local -x DJANGO_SETTINGS_MODULE=tests.ext.django.app.settings
	local -x AWS_SECRET_ACCESS_KEY=fake_key
	local -x AWS_ACCESS_KEY_ID=fake_id

	distutils-r1_src_test
}
