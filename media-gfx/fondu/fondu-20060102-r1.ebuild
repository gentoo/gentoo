# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/fondu/fondu-20060102-r1.ebuild,v 1.5 2014/03/05 15:48:11 ago Exp $

EAPI="5"

inherit eutils

MY_PV=${PV:2:6}

DESCRIPTION="Utilities for converting between and manipulating mac fonts and unix fonts"
HOMEPAGE="http://fondu.sourceforge.net/"
SRC_URI="http://fondu.sourceforge.net/${PN}_src-${MY_PV}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE=""

S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
	sed -e 's:^CFLAGS =:CFLAGS +=:' \
		-e 's:$(CFLAGS) -o:$(CFLAGS) $(LDFLAGS) -o:' \
		-e 's:wilprefix:prefix:' \
		-i Makefile.in || die "failed to sed"
	epatch "${FILESDIR}/${P}-build-fix.patch"
}

src_install() {
	default
	doman *.1
}
