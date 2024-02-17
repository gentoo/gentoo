# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A full-screen, console-based Python debugger"
HOMEPAGE="https://pypi.org/project/pudb/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/urwid[${PYTHON_USEDEP}]
	dev-python/urwid-readline[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_install() {
	rm -rf "${WORKDIR}"/${P}-${EPYTHON/./_}/install/usr/lib/${EPYTHON}/site-packages/test
	distutils-r1_python_install
}
