# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="An extension that maintains file IDs for documents in a running Jupyter Server"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter-server/jupyter_server_fileid/
	https://pypi.org/project/jupyter-server-fileid/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/jupyter-server[${PYTHON_USEDEP}]
	~dev-python/jupyter_events-0.5.0[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/pytest_jupyter[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all
	mv "${ED}/usr/etc" "${ED}/etc" || die
}
