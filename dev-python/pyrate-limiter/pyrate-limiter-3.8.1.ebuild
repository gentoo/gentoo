# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3_11 python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python Rate-Limiter using Leaky-Bucket Algorimth Family"
HOMEPAGE="
	https://github.com/vutran1710/PyrateLimiter/
	https://pypi.org/project/pyrate-limiter/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/filelock[${PYTHON_USEDEP}]
	dev-python/redis[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-db/redis
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# Optional dependency redis-py-cluster not packaged
	"tests/test_02.py::test_redis_cluster"
)
EPYTEST_PLUGINS=( pytest-{asyncio,rerunfailures} )
EPYTEST_XDIST=1

distutils_enable_sphinx docs \
	dev-python/sphinx-autodoc-typehints \
	dev-python/sphinx-copybutton \
	dev-python/furo \
	dev-python/myst-parser \
	dev-python/sphinxcontrib-apidoc
distutils_enable_tests pytest

src_test() {
	local redis_pid="${T}"/redis.pid
	local redis_port=6379

	# Spawn Redis itself for testing purposes
	einfo "Spawning Redis"
	einfo "NOTE: Port ${redis_port} must be free"
	"${EPREFIX}"/usr/sbin/redis-server - <<- EOF || die "Unable to start redis server"
		daemonize yes
		pidfile ${redis_pid}
		port ${redis_port}
		bind 127.0.0.1 ::1
		${extra_conf}
	EOF

	# Run the tests
	distutils-r1_src_test

	# Clean up afterwards
	kill "$(<"${redis_pid}")" || die
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	# postgres tests require psycopg-pool
	epytest --reruns=5 -k "not postgres"
}
