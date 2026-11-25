# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit-core
PYTHON_TESTED=( python3_{12..15} )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" python3_{14,15}t )

inherit distutils-r1

DESCRIPTION="Verify certificates using native system trust stores"
HOMEPAGE="
	https://github.com/sethmlarson/truststore/
	https://pypi.org/project/truststore/
"
SRC_URI="
	https://github.com/sethmlarson/truststore/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="test"
# The vast majority of tests require Internet access.
PROPERTIES="test? ( test_network )"
RESTRICT="test"

BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/aiohttp[${PYTHON_USEDEP}]
			dev-python/httpx[${PYTHON_USEDEP}]
			dev-python/pyopenssl[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-asyncio[${PYTHON_USEDEP}]
			dev-python/pytest-httpserver[${PYTHON_USEDEP}]
			dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
			dev-python/requests[${PYTHON_USEDEP}]
			dev-python/trustme[${PYTHON_USEDEP}]
			dev-python/urllib3[${PYTHON_USEDEP}]
		' "${PYTHON_TESTED[@]}")
	)
"

python_test() {
	if ! has "${EPYTHON/./_}" "${PYTHON_TESTED[@]}"; then
		einfo "Skipping tests on ${EPYTHON}"
		return
	fi

	local EPYTEST_PLUGINS=( pytest-{asyncio,httpserver,rerunfailures} )
	local EPYTEST_RERUNS=5
	epytest
}
