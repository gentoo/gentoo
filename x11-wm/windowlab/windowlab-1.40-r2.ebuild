# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="small and simple window manager of novel design"
HOMEPAGE="http://www.nickgravgaard.com/windowlab/"
SRC_URI="http://www.nickgravgaard.com/${PN}/${P}.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc x86"
IUSE="truetype"

RDEPEND="truetype? ( x11-libs/libXft )
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-1.34-fixed-font.patch"
	"${FILESDIR}/${P}-gentoo.diff"
	"${FILESDIR}/${PN}-1.40-libdir.patch"
)

src_configure() {
	if use truetype ; then
		export DEFINES=-DXFT
		export EXTRA_INC=$($(tc-getPKG_CONFIG) --cflags xft)
		export EXTRA_LIBS=$($(tc-getPKG_CONFIG) --libs xft)
	fi

	tc-export CC
}

src_install() {
	default

	exeinto /etc/X11/Sessions
	cat <<- EOF > "${T}"/${PN}
		#!/bin/sh
		exec /usr/bin/${PN}
	EOF
	doexe "${T}"/${PN}
}

pkg_postinst() {
	elog "${PN}'s menu config file has been changed from"
	elog "${EROOT}/etc/X11/${PN}/menurc to ${EROOT}/etc/X11/${PN}/${PN}.menurc"
}
