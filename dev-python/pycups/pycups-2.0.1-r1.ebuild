# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="Python bindings for the CUPS API"
HOMEPAGE="https://github.com/OpenPrinting/pycups"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86"
IUSE="examples"

RDEPEND="net-print/cups"
DEPEND="${RDEPEND}"

# https://github.com/OpenPrinting/pycups/commit/8cbf6d40a0132764ad51e7416aa7034966875091
PATCHES=( "${FILESDIR}/${P}-py3.10.patch" )

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
