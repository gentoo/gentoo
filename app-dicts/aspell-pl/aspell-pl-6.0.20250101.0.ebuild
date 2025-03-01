# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTE: bump togeter with myspell-pl

EAPI=8

ASPELL_LANG="Polish"
ASPELL_VERSION=6

inherit aspell-dict-r1

MY_P="${PN/aspell/aspell${ASPELL_VERSION}}-$(ver_rs 2 _ 3 -)"

HOMEPAGE="https://sjp.pl/sl/en/"
SRC_URI="https://sjp.pl/sl/ort/sjp-${MY_P}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2 LGPL-2.1 MPL-1.1 Apache-2.0 CC-BY-4.0" # upstream's order
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
