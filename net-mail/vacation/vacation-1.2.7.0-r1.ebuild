# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs

DESCRIPTION="automatic mail answering program"
HOMEPAGE="http://vacation.sourceforge.net/"
SRC_URI="mirror://sourceforge/vacation/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~x86"
SLOT="0"

RDEPEND="virtual/mta
	sys-libs/gdbm"
DEPEND="${RDEPEND}
	!mail-mta/sendmail"

src_prepare() {
	default

	sed -i -e "s:install -s -m:install -m:" Makefile || die "sed failed!"
	sed -i -e "s:-Xlinker:${LDFLAGS} -Xlinker:" Makefile || die "sed failed!"
}

src_compile () {
	emake CFLAGS="${CFLAGS} -DMAIN"
}

src_install () {
	dodir /usr/bin
	dodir /usr/share/man/man1
	emake BINDIR="${D}/usr/bin" MANDIR="${D}/usr/share/man/man" install
}
