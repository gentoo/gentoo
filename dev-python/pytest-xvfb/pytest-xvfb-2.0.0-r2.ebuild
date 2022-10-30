# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_REQ_USE="tk"
PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="A pytest plugin to run Xvfb for tests"
HOMEPAGE="https://pypi.org/project/pytest-xvfb/"
SRC_URI="https://github.com/The-Compiler/pytest-xvfb/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

RDEPEND="
	>=dev-python/pytest-2.8.1[${PYTHON_USEDEP}]
	>=dev-python/pyvirtualdisplay-1.3[${PYTHON_USEDEP}]
	x11-base/xorg-server[xvfb]
"

distutils_enable_tests pytest

python_test() {
	epytest -p xvfb
}
