# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ASPELL_LANG="Lithuanian"
ASPELL_VERSION=6
MY_P="${PN/aspell/aspell${ASPELL_VERSION}}-${PV}"

inherit aspell-dict-r1

HOMEPAGE="https://github.com/ispell-lt/ispell-lt"
SRC_URI="https://github.com/ispell-lt/ispell-lt/releases/download/rel-${PV}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
