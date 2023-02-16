# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Measures number of Terminal column cells of wide-character codes"
HOMEPAGE="
	https://pypi.org/project/wcwidth/
	https://github.com/jquast/wcwidth/
"
SRC_URI="
	https://github.com/jquast/wcwidth/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

distutils_enable_tests pytest

src_prepare() {
	sed -e 's:--cov-append::' \
		-e 's:--cov-report=html::' \
		-e 's:--cov=wcwidth::' \
		-i tox.ini || die
	distutils-r1_src_prepare
}

python_install_all() {
	docinto docs
	dodoc docs/intro.rst
	distutils-r1_python_install_all
}
