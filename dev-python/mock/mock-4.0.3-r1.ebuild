# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Rolling backport of unittest.mock for all Pythons"
HOMEPAGE="
	https://github.com/testing-cabal/mock/
	https://pypi.org/project/mock/
"
SRC_URI="
	https://github.com/testing-cabal/mock/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-python/six-1.9[${PYTHON_USEDEP}]
"
BDEPEND=${RDEPEND}

PATCHES=(
	"${FILESDIR}"/${P}-py310.patch
)

distutils_enable_tests pytest

python_install_all() {
	local DOCS=( CHANGELOG.rst README.rst )

	distutils-r1_python_install_all
}
