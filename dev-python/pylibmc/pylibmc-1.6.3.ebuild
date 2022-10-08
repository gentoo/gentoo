# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Libmemcached wrapper written as a Python extension"
HOMEPAGE="
	https://sendapatch.se/projects/pylibmc/
	https://pypi.org/project/pylibmc/
	https://github.com/lericson/pylibmc/
"
SRC_URI="
	https://github.com/lericson/pylibmc/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

DEPEND="
	>=dev-libs/libmemcached-0.32
"
RDEPEND="${DEPEND}"
BDEPEND="
	test? (
		net-misc/memcached
	)
"

PATCHES=(
	"${FILESDIR}/pylibmc-1.6.1-fix-test-failures-r1.patch"
)

distutils_enable_sphinx docs
distutils_enable_tests pytest

# needed for docs
export PYLIBMC_DIR=.

src_test() {
	local -x MEMCACHED_PORT=11219
	memcached -d -p "${MEMCACHED_PORT}" -u nobody -l localhost \
		-P "${T}/m.pid" || die
	distutils-r1_src_test
	kill "$(<"${T}/m.pid")" || die
}

python_test() {
	local EPYTEST_DESELECT=(
		# these require "AmazonElastiCache" running
		tests/test_autoconf.py
	)

	epytest --doctest-modules --doctest-glob='doctests.txt' src/pylibmc tests
}
