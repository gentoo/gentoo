# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/vice/vice-2.4.ebuild,v 1.12 2014/08/09 12:09:23 ago Exp $

EAPI=5
inherit autotools eutils toolchain-funcs games

DESCRIPTION="The Versatile Commodore 8-bit Emulator"
HOMEPAGE="http://vice-emu.sourceforge.net/"
SRC_URI="mirror://sourceforge/vice-emu/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="Xaw3d alsa gnome nls png readline sdl ipv6 memmap ethernet oss zlib X gif jpeg xv dga xrandr ffmpeg lame pulseaudio"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXt
	x11-libs/libXxf86vm
	x11-apps/xset
	Xaw3d? ( x11-libs/libXaw3d )
	!Xaw3d? ( !gnome? ( x11-libs/libXaw ) )
	alsa? ( media-libs/alsa-lib )
	gnome? (
		x11-libs/gtk+:2
		x11-libs/vte:0
		dev-libs/atk
		x11-libs/pango
	)
	lame? ( media-sound/lame )
	ffmpeg? ( virtual/ffmpeg )
	ethernet? (
	    >=net-libs/libpcap-0.9.8
	    >=net-libs/libnet-1.1.2.1
	)
	nls? ( virtual/libintl )
	png? ( media-libs/libpng:0 )
	readline? ( sys-libs/readline )
	sdl? ( media-libs/libsdl )
	gif? ( media-libs/giflib )
	jpeg? ( virtual/jpeg )
	xv? ( x11-libs/libXv )
	dga? ( x11-libs/libXxf86dga )
	xrandr? ( x11-libs/libXrandr )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-apps/bdftopcf
	x11-apps/mkfontdir
	x11-proto/xproto
	x11-proto/xf86vidmodeproto
	x11-proto/xextproto
	media-libs/fontconfig
	dga? ( x11-proto/xf86dgaproto )
	xv? ( x11-proto/videoproto )
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-arm.patch \
		"${FILESDIR}"/${P}-ffmpeg-1.patch \
		"${FILESDIR}"/${P}-buffer.patch \
		"${FILESDIR}"/${P}-autotools.patch
	sed -i \
		-e "s:/usr/local/lib/VICE:${GAMES_DATADIR}/${PN}:" \
		man/vice.1 \
		$(grep -rl --exclude="*texi" /usr/local/lib doc) \
		|| die
	sed -i \
		-e '/VICE_ARG_LIST_CHECK/d' \
		-e "/VICEDIR=/s:=.*:=\"${GAMES_DATADIR}/${PN}\";:" \
		configure.in || die
	sed -i \
		-e "s:\(#define LIBDIR \).*:\1\"${GAMES_DATADIR}/${PN}\":" \
		-e "s:\(#define DOCDIR \).*:\1\"/usr/share/doc/${PF}\":" \
		src/arch/unix/archdep.h \
		src/arch/sdl/archdep_unix.h
	mv configure.in configure.ac || die
	AT_NO_RECURSIVE=1 eautoreconf
}

src_configure() {
	# don't try to actually run fc-cache (bug #280976)
	FCCACHE=/bin/true \
	PKG_CONFIG=$(tc-getPKG_CONFIG) \
	egamesconf \
		--enable-fullscreen \
		--enable-parsid \
		--with-resid \
		--without-arts \
		--without-midas \
		$(use_enable ffmpeg) \
		$(use_enable lame) \
		$(use_enable gnome gnomeui) \
		$(use_enable nls) \
		$(use_with Xaw3d xaw3d) \
		$(use_with alsa) \
		$(use_with pulseaudio pulse) \
		$(use_with png) \
		$(use_with readline) \
		$(use_with sdl sdlsound) \
		$(use_enable ipv6) \
		$(use oss || echo --without-oss) \
		$(use_enable memmap) \
		$(use_enable ethernet) \
		$(use_with zlib) \
		$(use_with X x)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog FEEDBACK README
	prepgamesdirs
}
