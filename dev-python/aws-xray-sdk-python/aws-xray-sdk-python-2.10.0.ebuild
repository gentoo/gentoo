# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="AWS X-Ray SDK for Python"
HOMEPAGE="
	https://github.com/aws/aws-xray-sdk-python/
	https://pypi.org/project/aws-xray-sdk/
"
SRC_URI="
	https://github.com/aws/aws-xray-sdk-python/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/botocore-1.12.122[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/bottle[${PYTHON_USEDEP}]
		dev-python/flask-sqlalchemy[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-1.4[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.8.0-fix-py3.10-loops.patch"
)

distutils_enable_tests pytest

python_test() {
	local -x DJANGO_SETTINGS_MODULE=tests.ext.django.app.settings
	local -x AWS_SECRET_ACCESS_KEY=fake_key
	local -x AWS_ACCESS_KEY_ID=fake_id

	local EPYTEST_DESELECT=(
		# Internet access
		tests/test_patcher.py::test_external_file
		tests/test_patcher.py::test_external_module
		tests/test_patcher.py::test_external_submodules_full
		tests/test_patcher.py::test_external_submodules_ignores_file
		tests/test_patcher.py::test_external_submodules_ignores_module
		# benchmark
		tests/test_local_sampling_benchmark.py
	)
	local EPYTEST_IGNORE=(
		# unpackaged deps
		tests/ext/aiobotocore
		tests/ext/pg8000
		tests/ext/psycopg2
		tests/ext/pymysql
		tests/ext/pynamodb
		tests/ext/sqlalchemy_core/test_postgres.py
		tests/ext/django/test_db.py
		# Internet access
		tests/ext/httplib
		tests/ext/requests
		# requires old package vesions
		tests/ext/django
		tests/ext/aiohttp
	)

	epytest -p no:django
}
