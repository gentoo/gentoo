# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ASPELL_LANG="Norwegian Bokmal"
MY_P="${PN/aspell/aspell-${PV%.*}-${PV##*.}"

inherit aspell-dict-r1

SRC_URI="https://dev.gentoo.org/~conikost/distfiles/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="!app-dicts/aspell-no"
