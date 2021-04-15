# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

HOMEPAGE="
	https://pypi.org/project/requests-cache/
	https://github.com/reclosedev/requests-cache/"
DESCRIPTION="Persistent cache for requests library"
SRC_URI="
	https://github.com/reclosedev/requests-cache/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/url-normalize-1.4[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/pytest-httpbin[${PYTHON_USEDEP}]
		dev-python/timeout-decorator[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_test() {
	local skipped_tests=(
		# These require extra servers running
		tests/integration/test_dynamodb.py
		tests/integration/test_gridfs.py
		tests/integration/test_mongodb.py
		tests/integration/test_redis.py

		# TODO
#		'tests/integration/test_cache.py::test_all_response_formats[json]'
	)

	local -x USE_PYTEST_HTTPBIN=true
	epytest ${skipped_tests[@]/#/--deselect }
}
