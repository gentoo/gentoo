# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="A pure Python implementation of a sliding window memory map manager"
HOMEPAGE="
	https://pypi.org/project/smmap/
	https://github.com/gitpython-developers/smmap/"

LICENSE="BSD"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
SLOT="0"

distutils_enable_tests unittest
