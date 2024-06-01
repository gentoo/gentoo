# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1

DESCRIPTION="An elegant HTTP Cache implementation for HTTPX and HTTP Core"
HOMEPAGE="
	https://github.com/karpetrosyan/hishel
	https://pypi.org/project/hishel/
"
SRC_URI="https://github.com/karpetrosyan/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"

BDEPEND="
	${RDEPEND}
	dev-python/hatch-fancy-pypi-readme[${PYTHON_USEDEP}]
	test? (
		dev-db/redis
		dev-python/anyio[${PYTHON_USEDEP}]
		dev-python/boto3[${PYTHON_USEDEP}]
		dev-python/moto[${PYTHON_USEDEP}]
		dev-python/redis[${PYTHON_USEDEP}]
		dev-python/trio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -e 's:mock_s3:mock_aws:g' \
		-e '/import anysqlite/ d' \
		-i tests/_async/test_storages.py \
		tests/_sync/test_storages.py || die

	distutils-r1_python_prepare_all
}

src_test() {
	local EPYTEST_DESELECT=(
		# tests that need anysqlite
		tests/_async/test_storages.py::test_sqlitestorage
		tests/_async/test_storages.py::test_sqlite_expired
		tests/_async/test_storages.py::test_sqlite_ttl_after_hits
	)

	local redis_pid="${T}"/redis.pid
	local redis_port=6379

	einfo "Starting Redis"
	"${EPREFIX}"/usr/sbin/redis-server - <<- EOF
		daemonize yes
		pidfile ${redis_pid}
		port ${redis_port}
		bind 127.0.0.1 ::1
	EOF

	# Run the tests
	distutils-r1_src_test

	# Clean up afterwards
	kill "$(<"${redis_pid}")" || die
}
