# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ASPELL_LANG="Danish"

inherit aspell-dict-r1

HOMEPAGE="https://da.speling.org"
SRC_URI="https://da.speling.org/filer/new_${P}.tar.bz2"
S="${WORKDIR}/new_${P}"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~ppc-macos"
