# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Reimplementation of the Python stdlib smtpd.py based on asyncio"
HOMEPAGE="
	https://aiosmtpd.aio-libs.org/
	https://github.com/aio-libs/aiosmtpd
	https://pypi.org/project/aiosmtpd/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	>=dev-python/atpublic-4.0[${PYTHON_USEDEP}]
	>=dev-python/attrs-23.2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? ( >=dev-python/pytest-mock-3.12.0[${PYTHON_USEDEP}] )
"

EPYTEST_DESELECT=(
	# Needs dev-vcs/git
	aiosmtpd/qa/test_0packaging.py::TestVersion
)

distutils_enable_tests pytest

python_prepare_all() {
	sed -i -e '/--cov=/d' pytest.ini || die

	distutils-r1_python_prepare_all
}

python_test() {
	local EPYTEST_DESELECT=()
	case ${EPYTHON} in
		python3.13)
			EPYTEST_DESELECT+=(
				# https://github.com/aio-libs/aiosmtpd/issues/403
				aiosmtpd/tests/test_server.py::TestUnthreaded::test_unixsocket
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p pytest_mock
}
