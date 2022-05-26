# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ASPELL_LANG="Lower Saxony Plattdüütsch"
ASPELL_VERSION=6

inherit aspell-dict-r1

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_prepare() {
	default

	# Must be renamed, as it triggers otherwise a file collision with app-dicts/aspell-hi.
	sed -e 's/iso-8859-15/iso-8859-15-nds/g' -i Makefile.pre || die
	mv iso-8859-15.cmap iso-8859-15-nds.cmap || die
	mv iso-8859-15.cset iso-8859-15-nds.cset || die
}
