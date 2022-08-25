# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
# Note: greenlet is built-in in pypy
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Lightweight in-process concurrent programming"
HOMEPAGE="
	https://greenlet.readthedocs.io/en/latest/
	https://github.com/python-greenlet/greenlet/
	https://pypi.org/project/greenlet/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 -hppa -ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"

distutils_enable_sphinx docs
distutils_enable_tests unittest

python_test() {
	eunittest greenlet.tests
}
