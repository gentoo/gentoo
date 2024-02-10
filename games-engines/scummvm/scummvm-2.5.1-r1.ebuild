# Copyright 1999-2022 Gentoo Authors
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
	S="${WORKDIR}/${PN}-${P}"
fi

LICENSE="GPL-2+ LGPL-2.1 BSD GPL-3-with-font-exception"
SLOT="0"
IUSE="a52 aac alsa debug flac fluidsynth fribidi gif glew +gtk jpeg lua mpeg2 mp3 +net opengl png sndio speech theora truetype unsupported vorbis zlib"
RESTRICT="test"  # it only looks like there's a test there #77507

RDEPEND="
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
	net? (
		media-libs/sdl2-net
		net-misc/curl
	)
	opengl? (
		|| (
			virtual/opengl
			media-libs/mesa[gles2]
			media-libs/mesa[gles1]
		)
		glew? ( media-libs/glew:0= )
	)
	png? ( media-libs/libpng:0 )
	sndio? ( media-sound/sndio:= )
	speech? ( app-accessibility/speech-dispatcher )
	truetype? ( media-libs/freetype:2 )
	theora? ( media-libs/libtheora )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	zlib? ( sys-libs/zlib:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	truetype? ( virtual/pkgconfig )
	x86? ( dev-lang/nasm )
"

S="${WORKDIR}/${P/_/}"

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
		$(usex fluidsynth '' --disable-fluidsynth)
		$(use_enable fribidi)
		$(use_enable gif)
		$(use opengl && use_enable glew)
		$(use_enable gtk)
		$(use_enable jpeg)
		$(use_enable lua)
		$(use_enable mp3 mad)
		$(use_enable mpeg2)
		$(use_enable net libcurl)
		$(use_enable net sdlnet)
		$(use_enable png)
		$(use_enable sndio)
		$(use_enable speech tts)
		$(use_enable theora theoradec)
		$(use_enable truetype freetype2)
		$(usex unsupported --enable-all-engines '')
		$(use_enable vorbis)
		$(use_enable zlib)
		$(use_enable x86 nasm)
	)
	echo "configure ${myconf[@]}"
	# NOT AN AUTOCONF SCRIPT SO DONT CALL ECONF
	SDL_CONFIG="sdl2-config" \
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
