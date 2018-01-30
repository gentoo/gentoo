# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils multilib toolchain-funcs

DESCRIPTION="PaX regression test suite"
HOMEPAGE="https://pax.grsecurity.net"
SRC_URI="https://grsecurity.net/~spender/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	sys-apps/paxctl"

# EI_PAX flags are not strip safe.
RESTRICT="strip"

src_prepare() {
	mv Makefile.psm Makefile
	epatch "${FILESDIR}/${PN}-0.9.13-Makefile.patch"
	sed -i "s/^CC := gcc/CC := $(tc-getCC)/" Makefile
	sed -i "s/^LD := ld/LD := $(tc-getLD)/" Makefile
	eapply_user
}

src_compile() {
	emake RUNDIR=/usr/$(get_libdir)/paxtest || die
}

src_install() {
	emake DESTDIR="${D}" BINDIR=/usr/bin RUNDIR=/usr/$(get_libdir)/paxtest install || die

	newman debian/manpage.1.ex paxtest.1 || die
	dodoc ChangeLog README || die
}
