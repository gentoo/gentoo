# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Better INI parser for Python"
HOMEPAGE="
	https://github.com/candlepin/python-iniparse/
	https://pypi.org/project/iniparse/
"

LICENSE="MIT PSF-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"
IUSE=""

RDEPEND="
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
"

python_test() {
	"${EPYTHON}" runtests.py || die
}

python_install_all() {
	rm -rf "${ED}/usr/share/doc/${P}" || die
	distutils-r1_python_install_all
}
