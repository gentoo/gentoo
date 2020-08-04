# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="simple, lightweight library for creating and processing background jobs"
HOMEPAGE="https://python-rq.org https://github.com/rq/rq"
SRC_URI="https://github.com/rq/rq/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

BDEPEND="
	test? (
		dev-db/redis
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/sentry-sdk[${PYTHON_USEDEP}]
	)
"
DEPEND="
	>=dev-python/click-5.0[${PYTHON_USEDEP}]
	>=dev-python/redis-py-3.5.0[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/${PN}-1.5.0-no-install-tests.patch"
)

src_test() {
	local redis_pid="${T}"/redis.pid
	local redis_port=6379
	local redis_test_config="daemonize yes
		pidfile ${redis_pid}
		port ${redis_port}
		bind 127.0.0.1
	"

	# Spawn Redis itself for testing purposes
	# NOTE: On sam@'s machine, spawning Redis can hang in the sandbox.
	# I'm not restricting tests yet because this doesn't happen for anyone else AFAICT.
	elog "Spawning Redis"
	elog "NOTE: Port ${redis_port} must be free"
	/usr/sbin/redis-server - <<< "${redis_test_config}" || die

	# Run the actual tests
	distutils-r1_src_test

	# Clean up afterwards
	kill "$(<"${redis_pid}")" || die
}

python_test() {
	# Tests needing rqworker:
	# TestWorkerSubprocess::test_run_access_self, test_run_empty_queue, test_run_scheduled_access_self
	distutils_install_for_testing
	PATH="${BUILD_DIR}/test/scripts/:${PATH}" pytest -vv || die "Testsuite failed under ${EPYTHON}"
}
