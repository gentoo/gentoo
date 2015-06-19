# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/rec/rec-1.6.ebuild,v 1.9 2012/12/02 16:54:00 ulm Exp $

EAPI=4

inherit eutils

DESCRIPTION="Reverse Engineering Compiler"
HOMEPAGE="http://www.backerstreet.com/rec/rec.htm"
SRC_URI="http://www.backerstreet.com/rec/rec16lx.zip"

LICENSE="BSD-2 free-noncomm HPND"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RESTRICT="strip"

DEPEND="app-arch/unzip"
RDEPEND="
	sys-libs/ncurses
	sys-libs/gpm"

S=${WORKDIR}

QA_PREBUILT="/opt/bin/rec"

src_unpack() {
	unzip -L -d "${S}" -q "${DISTDIR}/${A}" || die
}

src_prepare() {
	sed -i 's#\(^.*$\)#/opt/rec/\1#g' proto.lst || die
}

src_compile() { :; }

src_install() {
	dodir /opt/rec
	into /opt
	dobin rec

	insinto /opt/rec
	doins proto.lst
	doins string.o stdio.o stdlib.o fcntl.o winbase.o winuser.o wingdi.o
	dodoc readme copyrite
}

pkg_postinst() {
	elog "/opt/rec/proto.lst should be copied into the working"
	elog "directory of new projects, this will make rec aware of common"
	elog "prototypes."
}
