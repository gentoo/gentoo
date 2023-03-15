# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="A Jupyter Server Extension Providing Terminals"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter-server/jupyter_server_terminals/
	https://pypi.org/project/jupyter-server-terminals/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-python/terminado[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/jupyter_server[${PYTHON_USEDEP}]
		dev-python/pytest_jupyter[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# Fails if shell is not bash
	tests/test_terminal.py::test_terminal_create_with_cwd
	tests/test_terminal.py::test_terminal_create_with_relative_cwd
)

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all
	mv "${ED}/usr/etc" "${ED}/etc" || die
}
