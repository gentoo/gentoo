# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A shim layer for notebook traits and config"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter/notebook_shim/
	https://pypi.org/project/notebook-shim/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	<dev-python/jupyter-server-3[${PYTHON_USEDEP}]
	>=dev-python/jupyter-server-1.8[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/pytest-tornasync[${PYTHON_USEDEP}]
		dev-python/pytest-jupyter[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p pytest_tornasync.plugin
}

src_install() {
	distutils-r1_src_install
	mv "${ED}/usr/etc" "${ED}/etc" || die
}
