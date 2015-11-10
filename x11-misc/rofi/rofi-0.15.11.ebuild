# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils toolchain-funcs

DESCRIPTION="A window switcher, run dialog and dmenu replacement"
HOMEPAGE="https://davedavenport.github.io/rofi/"
SRC_URI="https://github.com/DaveDavenport/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="i3 windowmode"
REQUIRED_USE="i3? ( windowmode )"

RDEPEND="
	dev-libs/glib:2
	media-libs/freetype
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/pango[X]
	x11-libs/startup-notification
	i3? ( x11-wm/i3 )
"
DEPEND="
	${RDEPEND}
	x11-proto/xineramaproto
	x11-proto/xproto
	virtual/pkgconfig
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-0.15.4-Werror.patch

	eautoreconf
}

src_configure() {
	tc-export CC
	econf \
		$(use_enable windowmode) \
		$(usex i3 '' --disable-i3support)
}

src_test() {
	emake test
}
