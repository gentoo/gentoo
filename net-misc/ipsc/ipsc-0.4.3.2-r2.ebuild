# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="IP Subnet Calculator"
HOMEPAGE="http://packages.debian.org/unstable/net/ipsc"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "s:^CC = gcc:CC = $(tc-getCC):" \
		-e "/^CFLAGS = .*/d" \
		-e "s/^LIBS = /LDLIBS = /" \
		-e '/$(CC).*\\$/,+1d' \
		-e '/$(CC)/d' \
		src/Makefile || die "Unable to sed upstream Makefile"
}

src_compile() {
	cd src
	emake || die "Compilation failed"
}

src_install() {
	dodoc README ChangeLog TODO CONTRIBUTORS
	dobin src/ipsc
	doman src/ipsc.1
}
