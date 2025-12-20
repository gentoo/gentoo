# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=uv-build
PYPI_VERIFY_REPO=https://github.com/pytest-dev/pytest-describe
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Describe-style plugin for pytest"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-describe/
	https://pypi.org/project/pytest-describe/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

RDEPEND="
	>=dev-python/pytest-6[${PYTHON_USEDEP}]
"

EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_PLUGINS=( "${PN}" )
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# unpin dependencies
	sed -i -e 's:,<[0-9]*::' pyproject.toml || die
}
