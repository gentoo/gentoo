# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils

DESCRIPTION="LCD and LED panel utilities for the Sun Cobalts"
HOMEPAGE="http://gentoo.404ster.com/"
SRC_URI="ftp://www.404ster.com/pub/gentoo-stuff/ebuilds/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~mips x86"
IUSE="static"

RDEPEND="sys-devel/gettext"
DEPEND="${DEPEND}
	sys-devel/autoconf"

src_configure() {
	sed -i \
		-e"/^COPTS/s:= := ${CFLAGS} :" \
		-e"/^LDFLAGS/s:= := ${LDFLAGS} :"\
		Makefile || die "sed failed"
}

src_compile() {
	if use static; then
		einfo "Building as static executables"
		export STATIC="-static"
	fi
	emake || die
}

src_install() {
	into /
	dosbin	"${S}"/lcd-flash "${S}"/lcd-getip "${S}"/lcd-swrite \
	"${S}"/lcd-write "${S}"/lcd-yesno "${S}"/lcd-setcursor "${S}"/iflink
	"${S}"/iflinkstatus "${S}"/readbutton || die "dosbin failed"

	dodoc doc/README* doc/CREDITS
	doman doc/man/*.1
}
