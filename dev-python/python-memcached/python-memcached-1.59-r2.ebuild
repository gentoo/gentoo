# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Pure python memcached client"
HOMEPAGE="
	https://github.com/linsomniac/python-memcached/
	https://pypi.org/project/python-memcached/
"
SRC_URI="
	https://github.com/linsomniac/python-memcached/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="PSF-2.4"
SLOT="0"
KEYWORDS="amd64 arm64 ppc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		net-misc/memcached
	)
"

distutils_enable_tests unittest

python_test() {
	local pidfile="${TMPDIR}/memcached.pid"

	memcached -d -P "${pidfile}" || die "failed to start memcached"

	eunittest || die "Tests fail with ${EPYTHON}"

	kill "$(<"${pidfile}")" || die "failed to kill memcached"
	local elapsed=0
	while [[ -f ${pidfile} ]]; do
		if [[ $(( elapsed++ )) -ge 30 ]]; then
			kill -KILL "$(<"${pidfile}")" ||
				die "failed to kill -KILL memcached"
			die "memcached failed to stop after 30 seconds"
		fi
		sleep 1
	done
}
