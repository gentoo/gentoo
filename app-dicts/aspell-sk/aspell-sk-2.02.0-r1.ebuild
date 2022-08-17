# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ASPELL_LANG="Slovak"
ASPELL_VERSION=6
MY_P="${PN/aspell/aspell${ASPELL_VERSION}}-${PV%.*}-${PV##*.}"

inherit aspell-dict-r1

HOMEPAGE="https://www.sk-spell.sk.cx/aspell-sk"
SRC_URI="https://spell.linux.sk/file_download/103/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2 LGPL-2.1 MPL-1.1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
