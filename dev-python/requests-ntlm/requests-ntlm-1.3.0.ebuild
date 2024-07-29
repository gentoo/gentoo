# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="HTTP NTLM authentication using the requests library"
HOMEPAGE="
	https://github.com/requests/requests-ntlm/
	https://pypi.org/project/requests-ntlm/
"
SRC_URI="
	https://github.com/requests/requests-ntlm/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/cryptography-1.3[${PYTHON_USEDEP}]
	>=dev-python/pyspnego-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/flask[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local ts_pid test_ret

	"${EPYTHON}" -m tests.test_server &> "${T}"/test-server.log &
	ts_pid=${!}

	nonfatal epytest tests/unit
	test_ret=${?}

	kill "${ts_pid}"
	[[ ${test_ret} -ne 0 ]] && die "Tests failed with ${EPYTHON}"
}
