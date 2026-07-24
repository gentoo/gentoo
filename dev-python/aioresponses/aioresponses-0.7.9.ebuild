# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Helper to mock/fake web requests in Python's aiohttp package"
HOMEPAGE="
	https://github.com/pnuckowski/aioresponses/
	https://pypi.org/project/aioresponses/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-python/aiohttp-3.8[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	test? (
		dev-python/ddt[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest

PATCHES=(
	# https://github.com/pnuckowski/aioresponses/pull/292
	"${FILESDIR}/${PN}-0.7.8-aiohttp-3.14.patch"
)

EPYTEST_DESELECT=(
	# These tests require Internet access
	tests/test_aioresponses.py::AIOResponsesTestCase::test_address_as_instance_of_url_combined_with_pass_through
	tests/test_aioresponses.py::AIOResponsesTestCase::test_pass_through_with_origin_params
	tests/test_aioresponses.py::AIOResponseRedirectTest::test_pass_through_unmatched_requests
)
