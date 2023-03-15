# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Python attributes without the boilerplate"
HOMEPAGE="
	https://characteristic.readthedocs.io/
	https://github.com/hynek/characteristic/
	https://pypi.org/project/characteristic/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

distutils_enable_tests pytest
distutils_enable_sphinx docs

python_prepare_all() {
	sed -e 's|\[pytest\]|\[tool:pytest\]|' -i setup.cfg || die
	distutils-r1_python_prepare_all
}
