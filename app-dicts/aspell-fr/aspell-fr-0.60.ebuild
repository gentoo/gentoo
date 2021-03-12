# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This is a hack to allow for using the French 0.50 dictionary until I have
# the time to do this properly. Do not stabilise this. (2021-03-12: yeah right)

ASPELL_LANG="French"
ASPELL_VERSION=6
inherit aspell-dict-r1

MY_P="aspell-fr-0.50-3"
SRC_URI="mirror://gnu/aspell/dict/fr/${MY_P}.tar.bz2"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~ppc-macos"
