# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="An elegant HTTP Cache implementation for HTTPX and HTTP Core"
HOMEPAGE="
	https://github.com/karpetrosyan/hishel/
	https://pypi.org/project/hishel/
"
SRC_URI="
	https://github.com/karpetrosyan/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/anyio-4.9.0[${PYTHON_USEDEP}]
	>=dev-python/anysqlite-0.0.5[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.28.1[${PYTHON_USEDEP}]
	>=dev-python/msgpack-1.1.2[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-1.14.1[${PYTHON_USEDEP}]
"

BDEPEND="
	${RDEPEND}
	dev-python/hatch-fancy-pypi-readme[${PYTHON_USEDEP}]
	test? (
		dev-db/redis
		>=dev-python/boto3-1.15.3[${PYTHON_USEDEP}]
		>=dev-python/inline-snapshot-0.28.0[${PYTHON_USEDEP}]
		>=dev-python/redis-6.2.0[${PYTHON_USEDEP}]
		>=dev-python/time-machine-2.19.0[${PYTHON_USEDEP}]
		>=dev-python/trio-0.30.0[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( anyio )
distutils_enable_tests pytest

src_test() {
	local EPYTEST_DESELECT=(
		# Internet
		tests/test_async_httpx.py
		tests/test_requests.py
		tests/test_sync_httpx.py
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
