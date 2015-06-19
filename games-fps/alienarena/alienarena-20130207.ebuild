# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/alienarena/alienarena-20130207.ebuild,v 1.1 2013/06/13 14:34:23 hasufell Exp $

EAPI=5
inherit autotools eutils gnome2-utils games

MY_PN=alienarena-7.65
DESCRIPTION="Fast-paced multiplayer deathmatch game"
HOMEPAGE="http://red.planetarena.org/"
SRC_URI="http://icculus.org/alienarena/Files/${MY_PN}-linux${PV}.tar.gz"

LICENSE="GPL-2 free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated +dga +vidmode +zlib"

UIRDEPEND="virtual/jpeg
	media-libs/openal
	media-libs/libvorbis
	media-libs/freetype:2
	virtual/glu
	virtual/opengl
	dga? ( x11-libs/libXxf86dga )
	vidmode? ( x11-libs/libXxf86vm )
	zlib? ( sys-libs/zlib )
	net-misc/curl"
UIDEPEND="dga? ( x11-proto/xf86dgaproto )
	vidmode? ( x11-proto/xf86vidmodeproto )"
RDEPEND="!dedicated? ( ${UIRDEPEND} )"
DEPEND="${RDEPEND}
	!dedicated? ( ${UIDEPEND} )
	virtual/pkgconfig"

S=${WORKDIR}/${MY_PN/_/.}

src_prepare() {
	epatch "${FILESDIR}"/${P}-nodocs.patch
	eautoreconf
}

src_configure() {
	egamesconf \
		--with-icondir=/usr/share/icons/hicolor/48x48/apps/ \
		--without-system-libode \
		$(use_enable !dedicated client) \
		$(use_with zlib) \
		$(use_with vidmode xf86vm) \
		$(use_with dga xf86dga)
}

src_install() {
	DOCS="docs/README.txt README" default
	if ! use dedicated ; then
		make_desktop_entry ${PN} "Alien Arena"
	fi
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
