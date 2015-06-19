# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/snes9x/snes9x-1.53.ebuild,v 1.13 2015/01/17 16:48:55 tupone Exp $

EAPI=5
inherit autotools eutils flag-o-matic multilib gnome2-utils games

DESCRIPTION="Super Nintendo Entertainment System (SNES) emulator"
HOMEPAGE="http://code.google.com/p/snes9x-gtk/"
SRC_URI="http://snes9x-gtk.googlecode.com/files/${P}-src.tar.bz2"

LICENSE="Snes9x GPL-2 GPL-2+ LGPL-2.1 LGPL-2.1+ ISC MIT ZLIB Info-ZIP"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE="alsa debug gtk joystick multilib netplay nls opengl oss png pulseaudio portaudio +xv +xrandr zlib"
RESTRICT="bindist"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	png? ( >=media-libs/libpng-1.2.43:0 )
	gtk? ( >=x11-libs/gtk+-2.10:2
		x11-misc/xdg-utils
		portaudio? ( >=media-libs/portaudio-19_pre )
		joystick? ( >=media-libs/libsdl-1.2.12[joystick] )
		opengl? ( virtual/opengl )
		xv? ( x11-libs/libXv )
		xrandr? ( x11-libs/libXrandr )
		alsa? ( media-libs/alsa-lib )
		pulseaudio? ( media-sound/pulseaudio ) )"
DEPEND="${RDEPEND}
	x11-proto/xproto
	gtk? ( virtual/pkgconfig
		xv? ( x11-proto/videoproto ) )
	nls? ( dev-util/intltool )"

S=${WORKDIR}/${P}-src/unix

pkg_setup() {
	games_pkg_setup
}

src_prepare() {
	cd "${WORKDIR}"/${P}-src
	sed -i -e '/pedantic/d' {gtk,unix}/configure.ac || die
	sed -i -e '75i#define OF(x) x' unzip/{un,}zip.h || die
	sed -i -e '22i#define OF(x) x' unzip/ioapi.h || die
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${P}-cross-compile.patch
	cd unix
	eautoreconf
	if use gtk; then
		cd ../gtk
		eautoreconf
	fi
}

src_configure() {
	append-ldflags -Wl,-z,noexecstack

	egamesconf \
		$(use_enable joystick gamepad) \
		$(use_enable debug debugger) \
		$(use_enable netplay) \
		$(use_enable zlib gzip) \
		$(use_enable zlib zip) \
		$(use_enable png screenshot)

	if use gtk; then
		cd ../gtk
		egamesconf \
			--datadir=/usr/share \
			$(use_enable nls) \
			$(use_with opengl) \
			$(use_with joystick) \
			$(use_with xv) \
			$(use_with xrandr) \
			$(use_with netplay) \
			$(use_with zlib) \
			$(use_with alsa) \
			$(use_with oss) \
			$(use_with pulseaudio) \
			$(use_with portaudio) \
			$(use_with png screenshot)
	fi
}

src_compile() {
	games_src_compile
	if use gtk; then
		emake -C ../gtk
	fi
}

src_install() {
	dogamesbin ${PN}

	dohtml {.,..}/docs/*.html
	dodoc ../docs/{snes9x.conf.default,{changes,control-inputs,controls,snapshots}.txt}

	if use gtk; then
		emake -C ../gtk DESTDIR="${D}" install
		dodoc ../gtk/{AUTHORS,doc/README}
	fi

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	use gtk && gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	use gtk && gnome2_icon_cache_update
}

pkg_postrm() {
	use gtk && gnome2_icon_cache_update
}
