# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ASPELL_LANG="Polish"
ASPELL_VERSION=6

inherit aspell-dict-r1

HOMEPAGE="https://sjp.pl/slownik/en/"

MY_P="sjp-${PN/aspell/aspell6}-$(ver_rs 2 _ 3 -)"
SRC_URI="https://sjp.pl/slownik/ort/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P/sjp-/}"

LICENSE="Apache-2.0 CC-BY-4.0 GPL-2 LGPL-2.1 MPL-1.1 "
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"
