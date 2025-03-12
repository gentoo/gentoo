# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A tool for generating OIDC identities"
HOMEPAGE="
	https://github.com/di/id/
	https://pypi.org/project/id/
"
# no tests in sdist, https://github.com/di/id/issues/286
SRC_URI="
	https://github.com/di/id/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc64 ~riscv sparc x86"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pretend[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()

	case ${EPYTHON} in
		pypy3*)
			EPYTEST_DESELECT+=(
				# https://github.com/di/id/issues/287
				test/unit/internal/oidc/test_ambient.py::test_gcp_bad_env
				test/unit/internal/oidc/test_ambient.py::test_gcp_wrong_product
				test/unit/internal/oidc/test_ambient.py::test_detect_gcp_request_fails
				test/unit/internal/oidc/test_ambient.py::test_detect_gcp_request_timeout
				test/unit/internal/oidc/test_ambient.py::test_detect_gcp
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
