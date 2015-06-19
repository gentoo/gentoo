# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmtimer/wmtimer-2.92-r1.ebuild,v 1.7 2014/04/07 18:06:45 ssuominen Exp $

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="Dockable clock which can run in alarm, countdown timer or chronograph mode"
HOMEPAGE="http://www.darkops.net/wmtimer"
SRC_URI="http://www.darkops.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2
	x11-libs/gtk+:2
	x11-libs/libXpm
	x11-libs/libXext
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${P}/${PN}

src_prepare() {
	sed -i -e "s:\$(CFLAGS)::" Makefile || die
	sed -i -e "s:-g::g" Makefile || die
	sed -i -e "s:-O2:\$(CFLAGS) ${CFLAGS}:"  Makefile || die
	sed -i -e "s:-o wmtimer:\$(LDFLAGS) -o wmtimer:" Makefile || die
	epatch "${FILESDIR}"/${PN}-counter-fix.patch
}

src_compile() {
	emake CC="$(tc-getCC)" LIBDIR="-L/usr/$(get_libdir)"
}

src_install() {
	dobin wmtimer
	dodoc ../{Changelog,CREDITS,README}
}
