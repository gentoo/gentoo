# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Send responses to HTTPX2 using pytest"
HOMEPAGE="
	https://github.com/angryfoxx/httpx2-pytest/
	https://pypi.org/project/httpx2-pytest/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/httpx2-2[${PYTHON_USEDEP}]
	>=dev-python/pytest-9[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( "${PN}" pytest-asyncio )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# unpin dependencies and remove pytest-cov
	sed -i -e '/==/{s:==:>=:;s:\.\*::}' -e '/--cov/d' pyproject.toml || die
}
