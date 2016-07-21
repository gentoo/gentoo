# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic games

DESCRIPTION="An emulator for the Sega Dreamcast system"
HOMEPAGE="http://www.lxdream.org/"
SRC_URI="http://www.lxdream.org/count.php?file=${P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug lirc profile pulseaudio sdl"

RDEPEND="lirc? ( app-misc/lirc )
	media-libs/alsa-lib
	media-libs/libpng:0
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( media-libs/libsdl[sound] )
	virtual/opengl
	x11-libs/gtk+:2"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
	virtual/os-headers
	!!gnustep-base/gnustep-gui" #377635

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.9.1-glib-single-include.patch"

	# Make .desktop file pass desktop-file-validate
	sed -i \
		-e '/Encoding/d' \
		-e '/FilePattern/d' \
		-e '/Categories/s|$|;|' \
		${PN}.desktop || die
	# Do not override user-specified CFLAGS
	sed -i \
		-e s/'CFLAGS=\"-g -fexceptions\"'/'CFLAGS=\"${CFLAGS} -g -fexceptions\"'/ \
		-e '/CCOPT/d' \
		-e '/OBJCOPT/d' \
		configure || die
	append-libs -lX11 -lm
}

src_configure() {
	egamesconf \
		--datadir="${GAMES_DATADIR_BASE}" \
		$(use_enable debug trace) \
		$(use_enable debug watch) \
		$(use_enable profile profiled) \
		$(use_with lirc) \
		$(use_with pulseaudio pulse) \
		$(use_with sdl) \
		--without-esd
}

src_install() {
	default
	prepgamesdirs
}
