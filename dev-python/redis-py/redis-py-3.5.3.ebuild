# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} pypy3 )

inherit distutils-r1

MY_PN="redis"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python client for Redis key-value store"
HOMEPAGE="https://github.com/andymccurdy/redis-py"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-db/redis
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	distutils-r1_python_prepare_all

	# Make sure that tests will be used from BUILD_DIR rather than cwd.
	mv tests tests-hidden || die

	# Correct local import patch syntax
	sed \
		-e 's:from .conftest:from conftest:' \
		-e 's:from .test_pubsub:from test_pubsub:' \
		-i tests-hidden/test_*.py \
		|| die
}

python_compile() {
	distutils-r1_python_compile

	if use test; then
		cp -r tests-hidden "${BUILD_DIR}"/tests || die
	fi
}

src_test() {
	local redis_pid="${T}"/redis.pid
	local redis_port=6379
	local redis_test_config="
		daemonize yes
		pidfile ${redis_pid}
		port ${redis_port}
		bind 127.0.0.1
	"

	# Spawn Redis itself for testing purposes
	# NOTE: On sam@'s machine, spawning Redis can hang in the sandbox.
	# I'm not restricting tests yet because this doesn't happen for anyone else AFAICT.
	elog "Spawning Redis"
	elog "NOTE: Port ${redis_port} must be free"
	"${EPREFIX}"/usr/sbin/redis-server - <<< "${redis_test_config}" || die

	# Run the tests
	distutils-r1_src_test

	# Clean up afterwards
	kill "$(<"${redis_pid}")" || die
}

distutils_enable_tests pytest
