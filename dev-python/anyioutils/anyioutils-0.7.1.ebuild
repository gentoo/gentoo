# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Utility classes and functions for AnyIO"
HOMEPAGE="
	https://github.com/davidbrochart/anyioutils/
	https://pypi.org/project/anyioutils/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test-rust"

RDEPEND="
	<dev-python/anyio-5[${PYTHON_USEDEP}]
	>=dev-python/anyio-4.8.0[${PYTHON_USEDEP}]
	<dev-python/outcome-2[${PYTHON_USEDEP}]
	>=dev-python/outcome-1.3.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/exceptiongroup[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	test? (
		test-rust? (
			dev-python/trio[${PYTHON_USEDEP}]
		)
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# requires aioguest
		tests/test_guest.py::test_host_trivial_guest_asyncio
	)
	local EPYTEST_IGNORE=()

	local args=()
	if ! has_version "dev-python/trio[${PYTHON_USEDEP}]"; then
		EPYTEST_IGNORE+=( tests/test_guest.py )
		args+=( -k "not trio" )
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p anyio "${args[@]}"
}
