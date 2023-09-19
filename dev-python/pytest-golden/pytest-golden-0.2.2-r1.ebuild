# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Plugin for pytest that offloads expected outputs to data files"
HOMEPAGE="
	https://github.com/oprypin/pytest-golden/
	https://pypi.org/project/pytest-golden/
"
# No tests in PyPI tarballs
SRC_URI="
	https://github.com/oprypin/pytest-golden/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	>=dev-python/atomicwrites-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-6.1.2[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.16.12[${PYTHON_USEDEP}]
	<dev-python/ruamel-yaml-1.0[${PYTHON_USEDEP}]
	>=dev-python/testfixtures-6.15.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	# poetry, sigh
	sed -i -e 's:\^:>=:' pyproject.toml || die
	distutils-r1_src_prepare
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_golden.plugin
	epytest -x
}
