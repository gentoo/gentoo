# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Pure Python module for getting image size from png/jpeg/jpeg2000/gif files"
HOMEPAGE="
	https://github.com/shibukawa/imagesize_py/
	https://pypi.org/project/imagesize/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-solaris"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# requires Internet
	test/test_get_filelike.py::test_get_filelike
)
