# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="flake8 plugin: McCabe complexity checker"
HOMEPAGE="https://github.com/PyCQA/mccabe"

KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
LICENSE="MIT"
SLOT="0"

RDEPEND="dev-python/flake8[${PYTHON_USEDEP}]"

BDEPEND="test? (
	dev-python/hypothesis[${PYTHON_USEDEP}]
)"

PATCHES=(
	"${FILESDIR}/${P}-fix-tests-without-hypothesmith.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	sed -i -e '/pytest-runner/d' setup.py || die
	distutils-r1_python_prepare_all
}
