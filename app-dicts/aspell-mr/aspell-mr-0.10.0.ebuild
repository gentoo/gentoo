# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ASPELL_LANG="Marathi"
ASPELL_VERSION=6

inherit aspell-dict-r1

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_prepare() {
	default

	# Must be renamed, as it triggers otherwise a file collision with app-dicts/aspell-hi.
	sed -e 's/u-deva/u-deva-mr/g' -i info -i Makefile.pre -i mr.dat || die
	mv u-deva.cmap u-deva-mr.cmap || die
	mv u-deva.cset u-deva-mr.cset || die
}
