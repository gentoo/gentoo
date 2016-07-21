# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils gnome2-utils games

MY_PN="${PN}_w_fonts"
DESCRIPTION="Educational arcade game where you have to solve maths problems"
HOMEPAGE="http://tux4kids.alioth.debian.org/tuxmath/"
SRC_URI="mirror://sourceforge/tuxmath/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2 OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls svg"

RDEPEND="dev-games/t4k-common[svg?]
	dev-libs/libxml2:2
	media-libs/libsdl:0
	media-libs/sdl-pango
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[mod]
	media-libs/sdl-net
	nls? ( virtual/libintl )
	svg? (
		gnome-base/librsvg:2
		x11-libs/cairo
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${MY_PN}-${PV}

src_prepare() {
	sed -i \
		-e '/\bdoc\b/d' \
		Makefile.in || die
	sed -i \
		-e '/strncat/s/)/ - 1)/' \
		src/server.c || die
}

src_configure() {
	egamesconf \
		--disable-dependency-tracking \
		--localedir=/usr/share/locale \
		$(use_enable nls) \
		$(usex svg "" "--without-rsvg")
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	doicon -s scalable data/images/icons/${PN}.svg
	make_desktop_entry ${PN} "TuxMath"
	dodoc doc/{README,TODO,changelog}
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
