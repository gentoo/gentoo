# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="A minimalistic X11 window manager"
HOMEPAGE="http://www.red-bean.com/~decklin/software/aewm/"
SRC_URI="${HOMEPAGE}${P}.tar.bz2"

LICENSE="MIT 9wm"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-proto/xextproto
	x11-proto/xproto
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	sed -i -e '/^font/s|".*"|"fixed"|g' doc/aewmrc.ex || die
	sed -i -e 's|skill|pkill|g' doc/clientsrc.ex || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		MANDIR="${D}/usr/share/man/man1" \
		XROOT="/usr" \
		install

	dodoc NEWS README
}
