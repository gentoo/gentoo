# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Fake implementation of redis API for testing purposes"
HOMEPAGE="
	https://github.com/jamesls/fakeredis/
	https://pypi.org/project/fakeredis/"
SRC_URI="
	https://github.com/jamesls/fakeredis/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	dev-python/redis-py[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/sortedcontainers[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local excludes=(
		# tests for use with aioredis, not packaged in ::gentoo
		--ignore test/test_aioredis.py
		# tests requiring lupa (lua support)
		-k 'not test_eval and not test_lua and not test_script'
	)

	epytest "${excludes[@]}"
}
