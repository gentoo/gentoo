# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..13} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi xdg-utils

DESCRIPTION="Jupyter Interactive Notebook"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter/notebook/
	https://pypi.org/project/notebook/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/jupyter-server-2.4.0[${PYTHON_USEDEP}]
	<dev-python/jupyter-server-3[${PYTHON_USEDEP}]
	>=dev-python/jupyterlab-4.5.1[${PYTHON_USEDEP}]
	<dev-python/jupyterlab-4.6[${PYTHON_USEDEP}]
	>=dev-python/jupyterlab-server-2.28.0[${PYTHON_USEDEP}]
	<dev-python/jupyterlab-server-3[${PYTHON_USEDEP}]
	>=dev-python/notebook-shim-0.2[${PYTHON_USEDEP}]
	<dev-python/notebook-shim-0.3[${PYTHON_USEDEP}]
	>=dev-python/tornado-6.2.0[${PYTHON_USEDEP}]
"

BDEPEND="
	>=dev-python/hatch-jupyter-builder-0.5[${PYTHON_USEDEP}]
	>=dev-python/jupyterlab-4.5[${PYTHON_USEDEP}]
	<dev-python/jupyterlab-4.6[${PYTHON_USEDEP}]
	test? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/nbval[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/requests-unixsocket[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{console-scripts,jupyter,timeout,tornasync} )
distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all
	mv "${ED}/usr/etc" "${ED}/etc" || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
