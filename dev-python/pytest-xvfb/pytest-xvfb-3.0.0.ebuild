# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="tk"

inherit distutils-r1 pypi

DESCRIPTION="Pytest plugin to run Xvfb for tests"
HOMEPAGE="
	https://github.com/The-Compiler/pytest-xvfb/
	https://pypi.org/project/pytest-xvfb/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/pyvirtualdisplay[${PYTHON_USEDEP}]
	x11-base/xorg-server[xvfb]
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_xvfb
	epytest --runpytest=subprocess
}
