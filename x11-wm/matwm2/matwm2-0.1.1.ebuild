# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/matwm2/matwm2-0.1.1.ebuild,v 1.3 2012/05/04 08:58:56 jdhore Exp $

EAPI=4
inherit toolchain-funcs

DESCRIPTION="Simple EWMH compatible window manager with titlebars and frames"
HOMEPAGE="http://squidjam.com/matwm/"
SRC_URI="http://squidjam.com/matwm/pub/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug xft xinerama"

RDEPEND="
	x11-libs/libXext
	x11-libs/libX11
	debug? ( x11-proto/xproto )
	xft? ( x11-libs/libXft )
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-proto/xextproto
	xinerama? ( x11-proto/xineramaproto )
"

src_configure() {
	# configure is not autotools based
	# --disable-shape left out because the code is broken
	./configure \
		$( use debug && echo --enable-debug ) \
		$( use xft || echo --disable-xft ) \
		$( use xinerama || echo --disable-xinerama ) \
		|| die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc BUGS ChangeLog default_matwmrc README TODO

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/${PN}.desktop

	echo ${PN} > "${T}"/${PN}
	exeinto /etc/X11/Sessions
	doexe "${T}"/${PN}
}
