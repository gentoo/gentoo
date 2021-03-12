# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ASPELL_LANG="Lithuanian"
ASPELL_VERSION=6
inherit aspell-dict-r1

MY_P="aspell6-lt-$(ver_rs 2 -)"
SRC_URI="mirror://gnu/aspell/dict/lt/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86"
