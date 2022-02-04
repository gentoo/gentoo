# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Full featured redis cache backend for Django"
HOMEPAGE="https://github.com/jazzband/django-redis/"
SRC_URI="mirror://pypi/${PN:0:1}"/${PN}/${P}.tar.gz

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/django-2.2[${PYTHON_USEDEP}]
	>=dev-python/redis-py-3.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-db/redis
		dev-python/lz4[${PYTHON_USEDEP}]
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/pytest-django[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -e '/--cov/d' -e '/--no-cov/d' -i setup.cfg || die
	distutils-r1_src_prepare
}

python_test() {
	cd tests || die
	local setting_file settings=(
		settings.sqlite
		settings.sqlite_json
		settings.sqlite_lz4
		settings.sqlite_msgpack
		settings.sqlite_sharding
		settings.sqlite_zlib
	)
	for setting_file in "${settings[@]}"; do
		einfo "Testing ${setting_file} configuration"
		epytest "--ds=${setting_file}"
	done
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
	einfo "Spawning Redis"
	einfo "NOTE: Port ${redis_port} must be free"
	"${EPREFIX}"/usr/sbin/redis-server - <<< "${redis_test_config}" || die

	# Run the tests
	distutils-r1_src_test

	# Clean up afterwards
	kill "$(<"${redis_pid}")" || die
}
