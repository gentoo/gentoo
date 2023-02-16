# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="ANSI Color formatting for output in terminal"
HOMEPAGE="
	https://github.com/termcolor/termcolor/
	https://pypi.org/project/termcolor/
"
# rename is for avoiding conflict with dev-cpp/termcolor
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz -> python-${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
