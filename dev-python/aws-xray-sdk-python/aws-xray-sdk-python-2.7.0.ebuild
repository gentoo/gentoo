# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="AWS X-Ray SDK for Python"
HOMEPAGE="https://github.com/aws/aws-xray-sdk-python https://pypi.org/project/aws-xray-sdk/"
SRC_URI="
	https://github.com/aws/aws-xray-sdk-python/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=dev-python/botocore-1.12.122[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/bottle[${PYTHON_USEDEP}]
		dev-python/django[${PYTHON_USEDEP}]
		dev-python/flask-sqlalchemy[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest-aiohttp[${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.4[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_test() {
	local -x DJANGO_SETTINGS_MODULE=tests.ext.django.app.settings
	local -x AWS_SECRET_ACCESS_KEY=fake_key
	local -x AWS_ACCESS_KEY_ID=fake_id

	local args=(
		# unpackaged deps
		--ignore tests/ext/aiobotocore
		--ignore tests/ext/pg8000
		--ignore tests/ext/psycopg2
		--ignore tests/ext/pymysql
		--ignore tests/ext/pynamodb
		--deselect tests/ext/django/test_db.py

		# Internet access
		--deselect
		tests/test_patcher.py::test_external_file
		--deselect
		tests/test_patcher.py::test_external_module
		--deselect
		tests/test_patcher.py::test_external_submodules_full
		--deselect
		tests/test_patcher.py::test_external_submodules_ignores_file
		--deselect
		tests/test_patcher.py::test_external_submodules_ignores_module
		--deselect
		tests/ext/aiohttp/test_client.py
		--ignore
		tests/ext/httplib
		--ignore
		tests/ext/requests
	)

	epytest "${args[@]}"
}
