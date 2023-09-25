# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="A Jupyter Server Extension Providing Y Documents"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter-server/jupyter_server_ydoc/
	https://pypi.org/project/jupyter-server-ydoc/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/jupyter-ydoc[${PYTHON_USEDEP}]
	dev-python/ypy-websocket[${PYTHON_USEDEP}]
	dev-python/jupyter-server-fileid[${PYTHON_USEDEP}]

"
BDEPEND="
	test? (
		dev-python/pytest-jupyter[${PYTHON_USEDEP}]
		dev-python/pytest-tornasync[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all
	mv "${ED}/usr/etc" "${ED}/etc" || die
}
