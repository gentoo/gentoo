# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Describe-style plugin for pytest"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-describe/
	https://pypi.org/project/pytest-describe/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"

RDEPEND="
	<dev-python/pytest-9[${PYTHON_USEDEP}]
	>=dev-python/pytest-2.6.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_describe.plugin
	epytest
}
