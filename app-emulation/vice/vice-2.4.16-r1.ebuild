# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/vice/vice-2.4.16-r1.ebuild,v 1.1 2015/02/11 03:05:43 mr_bones_ Exp $

EAPI=5
inherit autotools eutils toolchain-funcs flag-o-matic games

DESCRIPTION="The Versatile Commodore 8-bit Emulator"
HOMEPAGE="http://vice-emu.sourceforge.net/"
SRC_URI="mirror://sourceforge/vice-emu/releases/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="Xaw3d alsa ethernet ffmpeg fullscreen gtk gtk3 ipv6 lame nls oss png pulseaudio readline sdl threads vte zlib"

RDEPEND="
	virtual/jpeg
	virtual/opengl
	media-libs/giflib
	alsa? ( media-libs/alsa-lib )
	ethernet? (
	    >=net-libs/libpcap-0.9.8
	    >=net-libs/libnet-1.1.2.1
	)
	ffmpeg? ( virtual/ffmpeg )
	lame? ( media-sound/lame )
	nls? ( virtual/libintl )
	png? ( media-libs/libpng:0 )
	zlib? ( sys-libs/zlib )
	sdl? (
		media-libs/libsdl[joystick,sound,video]
	)
	!sdl? (
		x11-libs/libX11
		x11-libs/libXext
		fullscreen? (
			x11-libs/libXrandr
			x11-libs/libXxf86vm )
		readline? ( sys-libs/readline )
		gtk? (
			!gtk3? (
				x11-libs/gtk+:2
				vte? ( x11-libs/vte:0 )
			)
			gtk3? (
				x11-libs/gtk+:3
				vte? ( x11-libs/vte:2.90 )
			)
			x11-libs/pango
			x11-libs/cairo
			x11-libs/gtkglext
		)
		!gtk? (
			x11-libs/libX11
			x11-libs/libXmu
			x11-libs/libXpm
			x11-libs/libXt
			x11-libs/libXv
			sys-libs/readline
			Xaw3d? ( x11-libs/libXaw3d )
			!Xaw3d? ( x11-libs/libXaw )
		)
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	!sdl? (
		!gtk? (
			x11-libs/libICE
			x11-libs/libSM
		)
		x11-apps/bdftopcf
		x11-apps/mkfontdir
		x11-proto/xproto
		fullscreen? ( x11-proto/xf86vidmodeproto )
		x11-proto/xextproto
		media-libs/fontconfig
		x11-proto/videoproto
	)
	nls? ( sys-devel/gettext )"

pkg_pretend() {
	if use gtk || use gtk3 && use sdl ; then
		eerror "gtk (2 or 3) and sdl USE flags can't both be set.  Pick one and mask the other one in /etc/portage/package.use"
		die "Please pick one gui option."
	fi
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-autotools.patch
	sed -i \
		-e "s:/usr/local/lib/VICE:$(games_get_libdir)/${PN}:" \
		man/vice.1 \
		$(grep -rl --exclude="*texi" /usr/local/lib doc) \
		|| die
	sed -i \
		-e "/VICEDIR=/s:=.*:=\"$(games_get_libdir)/${PN}\";:" \
		configure.ac || die
	sed -i \
		-e "s:\(#define LIBDIR \).*:\1\"$(games_get_libdir)/${PN}\":" \
		-e "s:\(#define DOCDIR \).*:\1\"/usr/share/doc/${PF}\":" \
		src/arch/unix/archdep.h \
		src/arch/sdl/archdep_unix.h
	AT_NO_RECURSIVE=1 eautoreconf
}

src_configure() {
	local gui_arg

	if use sdl ; then
		gui_arg="--enable-sdlui"
	elif use gtk || use gtk3 ; then
		# The gtk UI code has raw calls to XOpenDisplay and
		# is missing -lX11 if vte doesn't pull it in.
		if ! use vte ; then
			append-libs -lX11
		fi
		gui_arg="--enable-gnomeui"
		if use gtk3 ; then
			gui_arg="--enable-gnomeui3"
		fi
	fi
	# don't try to actually run fc-cache (bug #280976)
	FCCACHE=/bin/true \
	PKG_CONFIG=$(tc-getPKG_CONFIG) \
	egamesconf \
		--enable-parsid \
		--with-resid \
		--without-arts \
		--without-midas \
		$(use_enable ethernet) \
		$(use_enable ffmpeg) \
		$(use_enable fullscreen) \
		$(use_enable ipv6) \
		$(use_enable lame) \
		$(use_enable nls) \
		$(use_enable vte) \
		$(use_with Xaw3d xaw3d) \
		$(use_with alsa) \
		$(use_with oss) \
		$(use_with png) \
		$(use_with pulseaudio pulse) \
		$(use_with readline) \
		$(use_with sdl sdlsound) \
		$(use_with threads uithreads) \
		$(use_with zlib) \
		${gui_arg} \
		--disable-option-checking
		# --disable-option-checking has to be last
}

src_install() {
	DOCS="AUTHORS ChangeLog FEEDBACK README" \
		default
	prepgamesdirs
}
