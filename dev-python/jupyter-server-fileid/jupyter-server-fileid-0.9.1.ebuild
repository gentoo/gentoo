# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="An extension that maintains file IDs for documents in a running Jupyter Server"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter-server/jupyter_server_fileid/
	https://pypi.org/project/jupyter-server-fileid/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/jupyter-server[${PYTHON_USEDEP}]
	dev-python/jupyter-events[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/pytest-jupyter[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# unreliable on tmpfs
	# https://github.com/jupyter-server/jupyter_server_fileid/issues/58
	tests/test_manager.py::test_get_path_oob_move_nested
	tests/test_manager.py::test_get_path_oob_move_deeply_nested
)

python_install_all() {
	distutils-r1_python_install_all
	mv "${ED}/usr/etc" "${ED}/etc" || die
}
