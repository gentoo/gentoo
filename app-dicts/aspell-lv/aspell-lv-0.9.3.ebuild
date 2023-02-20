# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ASPELL_LANG="Latvian"
ASPELL_VERSION=6
MY_PN="${PN/aspell/aspell${ASPELL_VERSION}}"
MY_P="${MY_PN}-${PV}"

inherit aspell-dict-r1

HOMEPAGE="http://dict.dv.lv/download.php?prj=lv"
SRC_URI="http://dict.dv.lv/download/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
