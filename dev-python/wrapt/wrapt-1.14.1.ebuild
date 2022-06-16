# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Module for decorators, wrappers and monkey patching"
HOMEPAGE="
	https://github.com/GrahamDumpleton/wrapt/
	https://pypi.org/project/wrapt/
"
SRC_URI="
	https://github.com/GrahamDumpleton/wrapt/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/sphinx_rtd_theme

python_compile() {
	local -x WRAPT_INSTALL_EXTENSIONS=true
	distutils-r1_python_compile
}
