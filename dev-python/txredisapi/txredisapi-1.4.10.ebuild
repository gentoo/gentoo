# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 optfeature

DESCRIPTION="Non-blocking redis client for python"
HOMEPAGE="
	https://github.com/IlyaSkriblovsky/txredisapi/
	https://pypi.org/project/txredisapi/
"
# Github is used because PyPI archive does not contain tests,
# see https://github.com/IlyaSkriblovsky/txredisapi/issues/149
SRC_URI="
	https://github.com/IlyaSkriblovsky/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP},ssl(-)]
"
BDEPEND="
	test? (
		dev-db/redis
		dev-python/hiredis[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	sed -i "/redis_sock =/s:/tmp:${T}:" tests/test_unix_connection.py || die

	distutils-r1_src_prepare
}

python_test() {
	# paralellized tests with -j parameter fail
	"${EPYTHON}" -m twisted.trial tests || die "tests failed with ${EPYTHON}"
}

src_test() {
	local redis_pid="${T}"/redis.pid
	local redis_port=6379

	if has_version ">=dev-db/redis-7"; then
		local extra_conf="
			enable-debug-command yes
			enable-module-command yes
		"
	fi

	# Spawn Redis itself for testing purposes
	einfo "Spawning Redis"
	einfo "NOTE: Port ${redis_port} must be free"
	"${EPREFIX}"/usr/sbin/redis-server - <<- EOF || die "Unable to start redis server"
		daemonize yes
		pidfile ${redis_pid}
		port ${redis_port}
		bind 127.0.0.1 ::1
		unixsocket ${T}/redis.sock
		unixsocketperm 700
		${extra_conf}
	EOF

	# Run the tests
	distutils-r1_src_test

	# Clean up afterwards
	kill "$(<"${redis_pid}")" || die
}

pkg_postinst() {
	optfeature "Use hiredis protocol parser" dev-python/hiredis
}
