# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Setuptools revision control system plugin for Git"
HOMEPAGE="
	https://github.com/msabramo/setuptools-git/
	https://pypi.org/project/setuptools-git/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-vcs/git
"
BDEPEND=${RDEPEND}

distutils_enable_tests unittest

src_test() {
	git config --global user.name "test user" || die
	git config --global user.email "test@email.com" || die
	distutils-r1_src_test
}
