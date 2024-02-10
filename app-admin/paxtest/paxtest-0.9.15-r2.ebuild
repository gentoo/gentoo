# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="PaX regression test suite"
HOMEPAGE="https://pax.grsecurity.net"
SRC_URI="https://grsecurity.net/~spender/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

DEPEND="sys-apps/paxctl"

# EI_PAX flags are not strip safe.
RESTRICT="strip"

PATCHES=(
	"${FILESDIR}/${PN}-0.9.13-Makefile.patch"
)

src_prepare() {
	mv Makefile.psm Makefile || die
	default
	sed -e "s/^CC := gcc/CC := $(tc-getCC)/" -i Makefile || die
	sed -e "s/^LD := ld/LD := $(tc-getLD)/" -i Makefile || die
}

src_compile() {
	emake RUNDIR=/usr/$(get_libdir)/paxtest
}

src_install() {
	emake DESTDIR="${ED}" BINDIR=/usr/bin RUNDIR=/usr/$(get_libdir)/paxtest install

	newman debian/manpage.1.ex paxtest.1
	dodoc ChangeLog README
}
