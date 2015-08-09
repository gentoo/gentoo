# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit autotools multilib

MY_P=fweelin-${PV/_}

DESCRIPTION="A live looping instrument using SDL and jack"
HOMEPAGE="http://freewheeling.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="fluidsynth"

RDEPEND="dev-libs/libxml2
	media-libs/alsa-lib
	media-libs/freetype:2
	media-libs/libvorbis
	media-libs/libsdl[sound,video,joystick]
	media-libs/libsndfile
	media-libs/sdl-gfx
	media-libs/sdl-ttf
	media-sound/jack-audio-connection-kit
	net-libs/gnutls
	x11-libs/libX11
	fluidsynth? ( media-sound/fluidsynth )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i -e 's:-L/usr/X11R6/lib::' configure.ac || die

	sed -i \
		-e '/CFLAGS/s:-g::' \
		-e '/CFLAGS/s:-funroll-loops.*::' \
		-e "s:local/lib/jack:$(get_libdir)/jack:" \
		src/Makefile.am || die

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable fluidsynth) \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TUNING

	docinto examples
	dodoc examples/*
}
