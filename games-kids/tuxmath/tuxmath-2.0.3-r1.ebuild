# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils gnome2-utils

MY_PN="${PN}_w_fonts"
DESCRIPTION="Educational arcade game where you have to solve maths problems"
HOMEPAGE="http://tux4kids.alioth.debian.org/tuxmath/"
SRC_URI="mirror://debian/pool/main/t/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls svg"

RDEPEND="dev-games/t4k-common[svg?]
	dev-libs/libxml2:2
	media-libs/libsdl:0[video]
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[mod]
	media-libs/sdl-net
	media-libs/sdl-pango
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
	default

	sed -i -e '/\bdoc\b/d' Makefile.in || die
}

src_configure() {
	econf \
		--localedir=/usr/share/locale \
		$(use_enable nls) \
		$(usex svg "" "--without-rsvg")
}

src_install() {
	default
	doicon -s scalable data/images/icons/${PN}.svg
	make_desktop_entry ${PN} "TuxMath"
	dodoc doc/{README,TODO,changelog}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
