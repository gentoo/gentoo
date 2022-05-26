# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ASPELL_LANG="Malayalam"
ASPELL_VERSION=6
MY_P="${PN/aspell/aspell${ASPELL_VERSION}}-${PV%.*}-${PV##*.}"

inherit aspell-dict-r1

SRC_URI="https://download-mirror.savannah.gnu.org/releases/smc/Spellchecker/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
