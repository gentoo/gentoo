# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Very fast and lightweight still powerful window manager for X"
HOMEPAGE="http://joewing.net/programs/jwm/"
SRC_URI="http://joewing.net/programs/jwm/releases/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86 ~x86-fbsd"
IUSE="bidi debug jpeg png truetype xinerama xpm"

RDEPEND="xpm? ( x11-libs/libXpm )
	xinerama? ( x11-libs/libXinerama )
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXau
	x11-libs/libXdmcp
	truetype? ( x11-libs/libXft )
	png? ( media-libs/libpng:0= )
	jpeg? ( virtual/jpeg:0= )
	bidi? ( dev-libs/fribidi )
	dev-libs/expat"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	xinerama? ( x11-proto/xineramaproto )"

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable truetype xft) \
		$(use_enable xinerama) \
		$(use_enable xpm) \
		$(use_enable bidi fribidi) \
		--enable-shape \
		--enable-xrender
}

src_install() {
	dodir /etc
	dodir /usr/bin
	dodir /usr/share/man

	default

	make_wrapper "${PN}" "/usr/bin/${PN}" "" "" "/etc/X11/Sessions"

	insinto "/usr/share/xsessions"
	doins "${FILESDIR}"/jwm.desktop

	dodoc README.md example.jwmrc ChangeLog
}

pkg_postinst() {
	einfo "JWM can be configured system-wide with ${EROOT}/etc/system.jwmrc"
	einfo "or per-user by creating a configuration file in ~/.jwmrc"
	einfo
	einfo "An example file can be found in ${EROOT}/usr/share/doc/${PF}/"
}
