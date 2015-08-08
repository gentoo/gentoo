# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="automatic mail answering program"
HOMEPAGE="http://vacation.sourceforge.net/"
SRC_URI="mirror://sourceforge/vacation/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 x86"
SLOT="0"
IUSE=""

RDEPEND="virtual/mta
	sys-libs/gdbm"
DEPEND="${RDEPEND}
	!mail-mta/sendmail"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i -e "s:install -s -m:install -m:" Makefile
	sed -i -e "s:-Xlinker:${LDFLAGS} -Xlinker:" Makefile
}

src_compile () {
	emake CC=$(tc-getCC) ARCH=$(tc-arch-kernel) CFLAGS="${CFLAGS} -DMAIN" || die "emake failed."
}

src_install () {
	dodir /usr/bin
	dodir /usr/share/man/man1
	emake BINDIR="${D}/usr/bin" MANDIR="${D}usr/share/man/man" install || die \
	"make install failed"
}
