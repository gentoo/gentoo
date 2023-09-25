# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Internationalized Domain Names in Applications (IDNA)"
HOMEPAGE="
	https://github.com/kjd/idna/
	https://pypi.org/project/idna/
"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

distutils_enable_tests unittest
