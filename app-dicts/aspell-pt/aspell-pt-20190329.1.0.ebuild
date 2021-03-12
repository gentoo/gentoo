# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ASPELL_LANG="Portuguese"
ASPELL_VERSION=6
MY_PN="${PN}_PT"
MY_P="${MY_PN/aspell/aspell${ASPELL_VERSION}}-${PV//./-}"

inherit aspell-dict-r1

SRC_URI="mirror://gnu/${PN%-*}/dict/${MY_PN/aspell-/}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
