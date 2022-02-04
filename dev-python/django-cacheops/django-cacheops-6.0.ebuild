# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="ORM cache with automatic granular event-driven invalidation for Django"
HOMEPAGE="https://github.com/Suor/django-cacheops"
SRC_URI="mirror://pypi/${PN:0:1}"/${PN}/${P}.tar.gz

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/django-1.8[${PYTHON_USEDEP}]
	>=dev-python/redis-py-2.9.1[${PYTHON_USEDEP}]
	>=dev-python/funcy-1.8[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-db/redis
		dev-python/dill[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	# Remove test dependent on unpackaged before_after
	sed -e 's/test_lock/_&/' -i tests/test_extras.py || die
	distutils-r1_src_prepare
}

python_test() {
	local -x DJANGO_SETTINGS_MODULE=tests.settings
	django-admin test -v 2 || die
}

src_test() {
	local redis_pid="${T}"/redis.pid
	local redis_port=6379

	einfo "Spawning Redis"
	einfo "NOTE: Port ${redis_port} must be free"
	"${EPREFIX}"/usr/sbin/redis-server - <<-EOF || die
		daemonize yes
		pidfile ${redis_pid}
		port ${redis_port}
		bind 127.0.0.1
	EOF

	# Run the tests
	distutils-r1_src_test

	# Clean up afterwards
	kill "$(<"${redis_pid}")" || die
}
