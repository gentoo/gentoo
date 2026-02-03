# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
# TODO: see if we can remove pypy3.11, because of the segfaults
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 optfeature

DESCRIPTION="Persistent cache for requests library"
HOMEPAGE="
	https://pypi.org/project/requests-cache/
	https://github.com/requests-cache/requests-cache/
"
SRC_URI="
	https://github.com/requests-cache/requests-cache/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-python/attrs-21.2[${PYTHON_USEDEP}]
	>=dev-python/cattrs-22.2[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2.5[${PYTHON_USEDEP}]
	>=dev-python/requests-2.22[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.25.5[${PYTHON_USEDEP}]
	>=dev-python/url-normalize-2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/itsdangerous[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		>=dev-python/rich-10.0[${PYTHON_USEDEP}]
		>=dev-python/ujson-5.4[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/time-machine[${PYTHON_USEDEP}]
		' 'python*')
	)
"

EPYTEST_PLUGINS=( pytest-httpbin requests-mock )
: ${EPYTEST_TIMEOUT:=60}
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

	case ${EPYTHON} in
		pypy3*)
			EPYTEST_DESELECT+=(
				# "database is locked", upstream probably relies on GC
				# too much
				tests/integration/test_sqlite.py
				# random segfaults
				tests/integration/test_filesystem.py
			)
			;;
	esac

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
