# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

MY_P=${P/-/_}
DESCRIPTION="Backported and Experimental Type Hints for Python 3.7+"
HOMEPAGE="
	https://pypi.org/project/typing-extensions/
	https://github.com/python/typing_extensions/
"
SRC_URI="
	https://github.com/python/typing_extensions/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

distutils_enable_tests unittest

python_test() {
	cd src || die
	eunittest
}
