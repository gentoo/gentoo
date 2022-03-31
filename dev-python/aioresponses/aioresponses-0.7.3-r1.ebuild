# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Helper to mock/fake web requests in Python's aiohttp package"
HOMEPAGE="https://github.com/pnuckowski/aioresponses"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/aiohttp[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	test? (
		dev-python/ddt[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# These tests require Internet access
	tests/test_aioresponses.py::AIOResponsesTestCase::test_address_as_instance_of_url_combined_with_pass_through
	tests/test_aioresponses.py::AIOResponsesTestCase::test_pass_through_with_origin_params
)
