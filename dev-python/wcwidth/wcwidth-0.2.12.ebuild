# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Measures number of Terminal column cells of wide-character codes"
HOMEPAGE="
	https://pypi.org/project/wcwidth/
	https://github.com/jquast/wcwidth/
"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"

distutils_enable_tests pytest

python_test() {
	epytest -o addopts=
}

python_install_all() {
	docinto docs
	dodoc docs/intro.rst
	distutils-r1_python_install_all
}
