# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Sleeplike program that counts down the number of seconds specified"
HOMEPAGE="https://onegeek.org/~tom/software/delay/"
SRC_URI="https://onegeek.org/~tom/software/delay/dl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="sys-libs/ncurses:0="
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	eapply \
		"${FILESDIR}"/${P}-headers.patch \
		"${FILESDIR}"/${P}-tinfo.patch

	mv configure.in configure.ac || die

	default
	eautoreconf
}
