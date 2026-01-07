# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Send responses to HTTPX using pytest"
HOMEPAGE="
	https://colin-b.github.io/pytest_httpx/
	https://github.com/Colin-b/pytest_httpx/
	https://pypi.org/project/pytest-httpx/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=dev-python/httpx-0.28[${PYTHON_USEDEP}]
	>=dev-python/pytest-8[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( "${PN}" pytest-asyncio )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# unpin dependencies
	sed -i -e '/==/{s:==:>=:;s:\.\*::}' pyproject.toml || die
}
