# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="tk"
inherit distutils-r1 pypi

DESCRIPTION="Pytest plugin to run Xvfb for tests"
HOMEPAGE="https://github.com/The-Compiler/pytest-xvfb/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/pyvirtualdisplay[${PYTHON_USEDEP}]
	x11-base/xorg-server[xvfb]
"

EPYTEST_PLUGINS=( ${PN} )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
distutils_enable_tests pytest
