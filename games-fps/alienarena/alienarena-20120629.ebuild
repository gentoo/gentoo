# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit autotools eutils games

MY_PN=alienarena-7.60
DESCRIPTION="Fast-paced multiplayer deathmatch game"
HOMEPAGE="http://red.planetarena.org/"
SRC_URI="http://icculus.org/alienarena/Files/${MY_PN}-linux${PV}.tar.gz"

LICENSE="GPL-2 free-noncomm"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dedicated +dga +vidmode"

UIRDEPEND="virtual/jpeg
	media-libs/openal
	media-libs/libvorbis
	media-libs/freetype:2
	virtual/glu
	virtual/opengl
	dga? ( x11-libs/libXxf86dga )
	vidmode? ( x11-libs/libXxf86vm )
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
		--disable-silent-rules \
		--disable-dependency-tracking \
		--with-icondir=/usr/share/pixmaps \
		--without-system-libode \
		$(use_enable !dedicated client) \
		$(use_with dga xf86dga) \
		$(use_with vidmode xf86vm)
}

src_install() {
	emake DESTDIR="${D}" install || die
	if ! use dedicated ; then
		make_desktop_entry ${PN} "Alien Arena"
	fi
	dodoc docs/README.txt README
	prepgamesdirs
}
