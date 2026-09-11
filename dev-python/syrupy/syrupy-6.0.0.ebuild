# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/syrupy-project/syrupy
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="The sweeter pytest snapshot plugin"
HOMEPAGE="
	https://github.com/syrupy-project/syrupy/
	https://pypi.org/project/syrupy/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/pytest-8.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/attrs-26.1.0[${PYTHON_USEDEP}]
		>=dev-python/pydantic-2.13.4[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGIN_LOAD_VIA_ENV=1
# pytest-xdist used inside tests
EPYTEST_PLUGINS=( "${PN}" hypothesis pytest-xdist )
distutils_enable_tests pytest

python_test() {
	epytest -o xfail_strict=False
}
