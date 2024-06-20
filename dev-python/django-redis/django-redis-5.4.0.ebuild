# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Full featured redis cache backend for Django"
HOMEPAGE="
	https://github.com/jazzband/django-redis/
	https://pypi.org/project/django-redis/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/django-3.2[${PYTHON_USEDEP}]
	>=dev-python/redis-3.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-db/redis
		dev-python/lz4[${PYTHON_USEDEP}]
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/pytest-django[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -e '/--cov/d' \
		-e '/--no-cov/d' \
		-i setup.cfg || die
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
		# TODO: requires pyzstd
#		settings.sqlite_zstd
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
