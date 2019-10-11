# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ASPELL_LANG="Danish"

inherit aspell-dict-r1

HOMEPAGE="https://da.speling.org"
SRC_URI="https://da.speling.org/filer/new_${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-macos"
IUSE=""

S="${WORKDIR}/new_${P}"
