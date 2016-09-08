# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils multilib toolchain-funcs

DESCRIPTION="PaX regression test suite"
HOMEPAGE="http://pax.grsecurity.net"
SRC_URI="http://grsecurity.net/~spender/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	sys-apps/paxctl"

# EI_PAX flags are not strip safe.
RESTRICT="strip"

QA_EXECSTACK="usr/bin/${PN}
	usr/$(get_libdir)/${PN}/getamap
	usr/$(get_libdir)/${PN}/shlibtest2.so
	usr/$(get_libdir)/${PN}/execheap
	usr/$(get_libdir)/${PN}/mprotstack
	usr/$(get_libdir)/${PN}/mprotdata
	usr/$(get_libdir)/${PN}/mprotheap
	usr/$(get_libdir)/${PN}/randshlib
	usr/$(get_libdir)/${PN}/randmain1
	usr/$(get_libdir)/${PN}/getshlib
	usr/$(get_libdir)/${PN}/randheap2
	usr/$(get_libdir)/${PN}/rettofunc2x
	usr/$(get_libdir)/${PN}/shlibdata
	usr/$(get_libdir)/${PN}/shlibbss
	usr/$(get_libdir)/${PN}/getmain1
	usr/$(get_libdir)/${PN}/execdata
	usr/$(get_libdir)/${PN}/execstack
	usr/$(get_libdir)/${PN}/rettofunc2
	usr/$(get_libdir)/${PN}/mprotshdata
	usr/$(get_libdir)/${PN}/getstack1
	usr/$(get_libdir)/${PN}/randamap
	usr/$(get_libdir)/${PN}/rettofunc1x
	usr/$(get_libdir)/${PN}/getheap2
	usr/$(get_libdir)/${PN}/getheap1
	usr/$(get_libdir)/${PN}/randheap1
	usr/$(get_libdir)/${PN}/getstack2
	usr/$(get_libdir)/${PN}/getmain2
	usr/$(get_libdir)/${PN}/rettofunc1
	usr/$(get_libdir)/${PN}/randstack2
	usr/$(get_libdir)/${PN}/mprotshbss
	usr/$(get_libdir)/${PN}/randstack1
	usr/$(get_libdir)/${PN}/mprotanon
	usr/$(get_libdir)/${PN}/randmain2
	usr/$(get_libdir)/${PN}/writetext
	usr/$(get_libdir)/${PN}/mprotbss
	usr/$(get_libdir)/${PN}/anonmap
	usr/$(get_libdir)/${PN}/execbss
	usr/$(get_libdir)/${PN}/shlibtest.so"

src_prepare() {
	mv Makefile.psm Makefile
	epatch "${FILESDIR}/${PN}-0.9.13-Makefile.patch"
	sed -i "s/^CC := gcc/CC := $(tc-getCC)/" Makefile
	sed -i "s/^LD := ld/LD := $(tc-getLD)/" Makefile
}

src_compile() {
	emake RUNDIR=/usr/$(get_libdir)/paxtest || die
}

src_install() {
	emake DESTDIR="${D}" BINDIR=/usr/bin RUNDIR=/usr/$(get_libdir)/paxtest install || die

	newman debian/manpage.1.ex paxtest.1 || die
	dodoc ChangeLog README || die
}
