# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 optfeature

HOMEPAGE="
	https://pypi.org/project/requests-cache/
	https://github.com/requests-cache/requests-cache/
"
DESCRIPTION="Persistent cache for requests library"
SRC_URI="
	https://github.com/requests-cache/requests-cache/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	>=dev-python/cattrs-22.2[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2.5[${PYTHON_USEDEP}]
	>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	>=dev-python/url-normalize-1.4[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/itsdangerous[${PYTHON_USEDEP}]
		dev-python/pytest-httpbin[${PYTHON_USEDEP}]
		dev-python/requests-mock[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		>=dev-python/rich-10.0[${PYTHON_USEDEP}]
		dev-python/timeout-decorator[${PYTHON_USEDEP}]
		>=dev-python/ujson-5.4[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/time-machine[${PYTHON_USEDEP}]
		' 'python*')
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# These require extra servers running
		tests/integration/test_dynamodb.py
		tests/integration/test_gridfs.py
		tests/integration/test_mongodb.py
		tests/integration/test_redis.py
	)
	local EPYTEST_DESELECT=(
		# Requires Internet access
		tests/integration/test_upgrade.py::test_version_upgrade
	)

	local -x USE_PYTEST_HTTPBIN=true
	epytest
}

pkg_postinst() {
	optfeature "redis backend" "dev-python/redis"
	optfeature "MongoDB backend" "dev-python/pymongo"

	optfeature "JSON serialization" "dev-python/ujson"
	optfeature "YAML serialization" "dev-python/pyyaml"
	optfeature "signing serialized data" "dev-python/itsdangerous"
}
