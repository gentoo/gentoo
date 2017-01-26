# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="Very fast and lightweight still powerful window manager for X"
HOMEPAGE="http://joewing.net/projects/jwm/"
SRC_URI="http://joewing.net/projects/${PN}/releases/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86 ~x86-fbsd"
IUSE="bidi cairo debug iconv jpeg nls png truetype xinerama xpm"

RDEPEND="dev-libs/expat
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXrender
	bidi? ( dev-libs/fribidi )
	cairo? (
		x11-libs/cairo
		gnome-base/librsvg
	)
	iconv? ( virtual/libiconv )
	jpeg? ( virtual/jpeg:0= )
	nls? ( sys-devel/gettext
		virtual/libintl )
	png? ( media-libs/libpng:0= )
	truetype? ( x11-libs/libXft )
	xinerama? ( x11-libs/libXinerama )
	xpm? ( x11-libs/libXpm )"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	xinerama? ( x11-proto/xineramaproto )"

src_configure() {
	econf \
		$(use_enable bidi fribidi) \
		$(use_enable cairo) \
		$(use_enable debug) \
		$(use_enable jpeg) \
		$(use_enable nls) \
		$(use_enable png) \
		$(use_enable cairo rsvg) \
		$(use_enable truetype xft) \
		$(use_enable xinerama) \
		$(use_enable xpm) \
		$(use_with iconv libiconv-prefix /usr) \
		$(use_with nls libintl-prefix /usr) \
		--enable-shape \
		--enable-xrender \
		--disable-rpath
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
