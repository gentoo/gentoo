# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/windowlab/windowlab-1.40.ebuild,v 1.3 2014/08/10 20:00:35 slyfox Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="small and simple window manager of novel design"
HOMEPAGE="http://www.nickgravgaard.com/windowlab/"
SRC_URI="http://www.nickgravgaard.com/${PN}/${P}.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~x86"
IUSE="truetype"

RDEPEND="truetype? ( x11-libs/libXft )
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	virtual/pkgconfig"

pkg_setup() {
	if use truetype ; then
		export DEFINES=-DXFT
		export EXTRA_INC=$(pkg-config --cflags xft)
		export EXTRA_LIBS=$(pkg-config --libs xft)
	fi
	tc-export CC
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.34-fixed-font.patch" \
		"${FILESDIR}"/${P}-gentoo.diff
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc CHANGELOG README TODO || die

	exeinto /etc/X11/Sessions
	cat <<- EOF > "${T}"/${PN}
		#!/bin/sh
		exec /usr/bin/${PN}
	EOF
	doexe "${T}"/${PN}
}

pkg_postinst() {
	elog "${PN}'s menu config file has been changed from"
	elog "/etc/X11/${PN}/menurc to /etc/X11/${PN}/${PN}.menurc"
}
