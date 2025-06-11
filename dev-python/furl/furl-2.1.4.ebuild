# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="URL parsing and manipulation made easy"
HOMEPAGE="https://pypi.org/project/furl/"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/orderedmultidict[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		tests/test_furl.py::TestFurl::test_hosts
		tests/test_furl.py::TestFurl::test_netloc
		tests/test_furl.py::TestFurl::test_odd_urls
	)
	epytest tests
}
