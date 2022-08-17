# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ASPELL_LANG="Portuguese"
ASPELL_VERSION=6
MY_PN="${PN/-/.}"
MY_P="${MY_PN/aspell/aspell${ASPELL_VERSION}}-${PV}"
MY_S="${PN/aspell/aspell${ASPELL_VERSION}}-${PV}"

inherit aspell-dict-r1

HOMEPAGE="https://natura.di.uminho.pt/wiki/doku.php?id=dicionarios:main"
SRC_URI="https://natura.di.uminho.pt/download/sources/Dictionaries/aspell${ASPELL_VERSION}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_S/pt/pt_PT}-0"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
