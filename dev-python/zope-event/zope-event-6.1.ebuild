# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( python3_{11..14} python3_{13..14}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Event publishing / dispatch, used by Zope Component Architecture"
HOMEPAGE="
	https://pypi.org/project/zope.event/
	https://github.com/zopefoundation/zope.event/
"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

distutils_enable_tests unittest

python_test() {
	eunittest -s "${BUILD_DIR}/install$(python_get_sitedir)/zope"
}
