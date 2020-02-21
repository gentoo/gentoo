# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Versatile Commodore 8-bit Emulator"
HOMEPAGE="http://vice-emu.sourceforge.net/"
SRC_URI="mirror://sourceforge/vice-emu/releases/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="alsa ethernet ffmpeg fullscreen +gtk ipv6 lame libav nls oss png pulseaudio sdl +sdlsound threads vte Xaw3d zlib"

# upstream says gtk3 and sdl2 shouldn't be exposed yet.
#REQUIRED_USE="?? ( gtk2 gtk3 sdl )"
REQUIRED_USE="?? ( gtk sdl )"

#	gtk3? (
#		x11-libs/cairo
#		x11-libs/gtk+:3
#		x11-libs/pango
#		vte? ( x11-libs/vte:2.90 )
#	)
RDEPEND="
	media-libs/giflib
	virtual/jpeg:0
	virtual/opengl
	alsa? ( media-libs/alsa-lib )
	ethernet? (
	    >=net-libs/libpcap-0.9.8
	    >=net-libs/libnet-1.1.2.1:1.1
	)
	ffmpeg? (
		libav? ( media-video/libav:= )
		!libav? ( media-video/ffmpeg:= )
	)
	gtk? (
		x11-libs/cairo
		x11-libs/gtk+:2
		x11-libs/gtkglext
		x11-libs/pango
		vte? ( x11-libs/vte:0 )
	)
	lame? ( media-sound/lame )
	nls? ( virtual/libintl )
	png? ( media-libs/libpng:0= )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( media-libs/libsdl[joystick,video] )
	!sdl? (
		sys-libs/readline:0=
		x11-libs/libX11
		x11-libs/libXext
		fullscreen? (
			x11-libs/libXrandr
			x11-libs/libXxf86vm
		)
		!gtk? (
			x11-libs/libXmu
			x11-libs/libXpm
			x11-libs/libXt
			x11-libs/libXv
			Xaw3d? ( x11-libs/libXaw3d )
			!Xaw3d? ( x11-libs/libXaw )
		)
	)
	sdlsound? ( media-libs/libsdl[sound] )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	media-libs/fontconfig
	x11-apps/bdftopcf
	>=x11-apps/mkfontscale-1.2.0
	x11-base/xorg-proto
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	!gtk? ( !sdl? (
			x11-libs/libICE
			x11-libs/libSM
	) )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.27-autotools.patch
	"${FILESDIR}"/${P}-ffmpeg4.patch
)

src_prepare() {
	default
	sed -i \
		-e 's/building//' \
		doc/Makefile.am || die
	sed -i \
		-e "/^docdir =/s:=.*:=/usr/share/doc/${PF}:" \
		doc/Makefile.am \
		doc/readmes/Makefile.am || die
	sed -i \
		-e "/^docdir =/s:=.*:=/usr/share/doc/${PF}/html:" \
		doc/html/Makefile.am || die
	sed -i \
		-e "s:/usr/local/lib/VICE:/usr/$(get_libdir)/${PN}:" \
		man/vice.1 \
		$(grep -rl --exclude="*texi" /usr/local/lib doc) || die
	sed -i \
		-e "/VICEDIR=/s:=.*:=\"/usr/$(get_libdir)/${PN}\";:" \
		configure.ac || die
	sed -i \
		-e "s:\(#define LIBDIR \).*:\1\"/usr/$(get_libdir)/${PN}\":" \
		-e "s:\(#define DOCDIR \).*:\1\"/usr/share/doc/${PF}\":" \
		src/arch/unix/archdep.h \
		src/arch/sdl/archdep_unix.h || die
	rm -rf src/lib/{libffmpeg,liblame} || die
	sed -i \
		-e '/SUBDIRS/s/libffmpeg//;' \
		-e '/SUBDIRS/s/liblame//;' \
		src/lib/Makefile.am || die
	AT_NO_RECURSIVE=1 eautoreconf
}

src_configure() {
	local gui_arg=() snd_arg=()

	snd_arg+=( $(use_with alsa) )
	snd_arg+=( $(use_with oss) )
	snd_arg+=( $(use_with pulseaudio pulse) )
	snd_arg+=( $(use_with sdlsound) )

	gui_arg+=( $(use_enable sdl sdlui) )
	# The gtk UI code has raw calls to XOpenDisplay and
	# is missing -lX11 if vte doesn't pull it in.
	#if use gtk2 || use gtk3 ; then
	if use gtk ; then
		use vte || append-libs -lX11
	fi
	gui_arg+=( $(use_enable gtk gnomeui) )
	#gui_arg+=" $(use_enable gtk3 gnomeui3)"
	gui_arg+=( $(use_enable Xaw3d xaw3d) )

	# --with-readline is forced to avoid using the embedded copy
	# don't try to actually run fc-cache (bug #280976)
	FCCACHE=/bin/true \
	PKG_CONFIG=$(tc-getPKG_CONFIG) \
	econf \
		--enable-parsid \
		--with-resid \
		--with-readline \
		--without-arts \
		--without-midas \
		$(use_enable ethernet) \
		$(use_enable ffmpeg) \
		$(use_enable ffmpeg external-ffmpeg) \
		$(use_enable fullscreen) \
		$(use_enable ipv6) \
		$(use_enable lame) \
		$(use_enable nls) \
		$(use_enable vte) \
		$(use_with png) \
		$(use_with threads uithreads) \
		$(use_with zlib) \
		"${gui_arg[@]}" \
		"${snd_arg[@]}" \
		--disable-option-checking
		# --disable-option-checking has to be last
}

src_install() {
	default
	dodoc FEEDBACK
}
