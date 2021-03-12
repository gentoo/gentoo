# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ASPELL_LANG="Brazilian Portuguese"
ASPELL_VERSION=6
MY_ASPELL_LANG="${PN#*-}"
MY_ASPELL_SUBLANG="${PN##*-}"
MY_P="aspell${ASPELL_VERSION}-${MY_ASPELL_LANG/-${PN##*-}/_${MY_ASPELL_SUBLANG^^}}-${PV//./-}"

inherit aspell-dict-r1

SRC_URI="mirror://gnu/${PN%%-*}/dict/${MY_ASPELL_LANG/-${PN##*-}/_${MY_ASPELL_SUBLANG^^}}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
