# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic toolchain-funcs xdg

DESCRIPTION="Reimplementation of the SCUMM game engine used in Lucasarts adventures"
HOMEPAGE="https://www.scummvm.org/"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scummvm/scummvm"
else
	SRC_URI="https://downloads.scummvm.org/frs/scummvm/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~x86"
	S=${WORKDIR}/${P/_/}
fi

LICENSE="GPL-2+ LGPL-2.1 BSD GPL-3-with-font-exception"
SLOT="0"
IUSE="
	a52 aac alsa debug flac fluidsynth fribidi gif +gtk jpeg lua mpeg2
	mp3 musepack +net opengl openmpt parport png readline sndio speech
	theora truetype unsupported vorbis vpx zlib
"
RESTRICT="test"  # it only looks like there's a test there #77507

DEPEND="
	>=media-libs/libsdl2-2.0.0[sound,joystick,video]
	a52? ( media-libs/a52dec )
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	flac? ( media-libs/flac:= )
	fluidsynth? ( media-sound/fluidsynth:= )
	fribidi? ( dev-libs/fribidi )
	gif? ( media-libs/giflib )
	gtk? (
		dev-libs/glib:2
		x11-libs/gtk+:3
	)
	jpeg? ( media-libs/libjpeg-turbo:= )
	mp3? ( media-libs/libmad )
	mpeg2? ( media-libs/libmpeg2 )
	musepack? ( media-sound/musepack-tools:= )
	net? (
		media-libs/sdl2-net
		net-misc/curl
	)
	opengl? (
		|| (
			virtual/opengl
			media-libs/libglvnd
		)
	)
	openmpt? ( media-libs/libopenmpt:= )
	parport? ( sys-libs/libieee1284:= )
	png? ( media-libs/libpng:0 )
	readline? ( sys-libs/readline:= )
	sndio? ( media-sound/sndio:= )
	speech? ( app-accessibility/speech-dispatcher )
	truetype? ( media-libs/freetype:2 )
	theora? ( media-libs/libtheora:= )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	vpx? ( media-libs/libvpx:= )
	zlib? ( virtual/zlib:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	app-arch/xz-utils
	truetype? ( virtual/pkgconfig )
	x86? ( dev-lang/nasm )
"

src_prepare() {
	default

	# -g isn't needed for nasm here
	sed -i \
		-e '/NASMFLAGS/ s/-g//' \
		configure || die
	sed -i \
		-e '/INSTALL.*doc/d' \
		-e '/INSTALL.*\/pixmaps/d' \
		-e 's/-s //' \
		ports.mk || die
}

src_configure() {
	use x86 && append-ldflags -Wl,-z,noexecstack
	tc-export STRINGS

	local myconf=(
		--backend=sdl
		--host=${CHOST}
		--enable-verbose-build
		--prefix="${EPREFIX}/usr"
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--opengl-mode=$(usex opengl auto none)
		--with-sdl-prefix="${EPREFIX}/usr"
		$(use_enable a52)
		$(use_enable aac faad)
		$(use_enable alsa)
		$(use_enable debug)
		$(use_enable !debug release-mode)
		$(use_enable flac)
		$(use_enable fluidsynth)
		$(use_enable fribidi)
		$(use_enable gif)
		$(use_enable gtk)
		$(use_enable jpeg)
		$(use_enable lua)
		# it's exclusive to openmpt, and openmpt is preferred upstream
		--disable-mikmod
		$(use_enable mp3 mad)
		$(use_enable mpeg2)
		$(use_enable musepack mpcdec)
		$(use_enable net libcurl)
		$(use_enable net sdlnet)
		$(use_enable openmpt)
		$(use_enable parport opl2lpt)
		$(use_enable png)
		$(use_enable readline)
		$(use_enable sndio)
		$(use_enable speech tts)
		--enable-text-console
		$(use_enable theora theoradec)
		$(use_enable truetype freetype2)
		$(usex unsupported --enable-all-engines '')
		$(use_enable vorbis)
		$(use_enable vpx)
		$(use_enable zlib)
		$(use_enable x86 nasm)
	)
	echo "configure ${myconf[@]}"
	# not an autoconf script, so don't call econf
	local -x SDL_CONFIG="sdl2-config"
	./configure "${myconf[@]}" ${EXTRA_ECONF} || die
}

src_compile() {
	emake \
		AR="$(tc-getAR) cru" \
		RANLIB="$(tc-getRANLIB)"
}

src_install() {
	default
	doicon -s scalable icons/scummvm.svg
}
