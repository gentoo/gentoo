# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="displays a count and a graph of the traffic over a specified network connection"
LICENSE="GPL-2"
HOMEPAGE="http://www.xs4all.nl/~rsmith/software/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"

DEPEND="
	x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXaw
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e 's:CFLAGS = -pipe -O2 -Wall:CFLAGS += -Wall:' \
		-e 's:LFLAGS = -s -pipe:LFLAGS = $(LDFLAGS):' \
		-e 's:gcc -MM:$(CC) -MM:' \
		-e 's:/usr/X11R6:/usr:g' \
		Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin xnetload
	doman xnetload.1
	dodoc ChangeLog README
	insinto /usr/share/X11/app-defaults/
	doins XNetload
}
