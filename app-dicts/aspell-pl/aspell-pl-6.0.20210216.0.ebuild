# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ASPELL_LANG="Polish"
ASPELL_VERSION=6

inherit aspell-dict-r1 eapi7-ver

MY_P="sjp-${PN/aspell/aspell6}-$(ver_rs 2 _ $(ver_rs 3 -))"

HOMEPAGE="https://sjp.pl/slownik/en/"
SRC_URI="https://www.sjp.pl/slownik/ort/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P/sjp-/}"

LICENSE="Apache-2.0 CC-BY-4.0 GPL-2 LGPL-2.1 MPL-1.1 "
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
