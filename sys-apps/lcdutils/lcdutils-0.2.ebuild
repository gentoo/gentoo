# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Cobalt RaQ/Qube LCD Writing and Button reading utilities"
HOMEPAGE="http://people.debian.org/~pm/mips-cobalt/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~mips ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e "s:CFLAGS=-O2 -Wall:CFLAGS=${CFLAGS}:g" Makefile
	epatch "${FILESDIR}"/include-stdlib.h-for-exit.patch
}

src_compile() {
	emake distclean || die "distclean failed"
	emake all || die "all failed"
}

src_install() {
	dobin buttond putlcd || die "dobin failed"
	dodoc ChangeLog || die "dodoc failed"
}
