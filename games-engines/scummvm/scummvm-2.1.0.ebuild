# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop flag-o-matic toolchain-funcs xdg

DESCRIPTION="Reimplementation of the SCUMM game engine used in Lucasarts adventures"
HOMEPAGE="https://www.scummvm.org/"
SRC_URI="https://scummvm.org/frs/scummvm/${PV}/${P}.tar.xz"

LICENSE="GPL-2+ LGPL-2.1 BSD GPL-3-with-font-exception"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="a52 aac alsa debug flac fluidsynth jpeg lua mpeg2 mp3 net opengl png speech theora truetype unsupported vorbis zlib"
RESTRICT="test"  # it only looks like there's a test there #77507

RDEPEND="
	>=media-libs/libsdl2-2.0.0[sound,joystick,video]
	a52? ( media-libs/a52dec )
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	flac? ( media-libs/flac )
	fluidsynth? ( media-sound/fluidsynth )
	jpeg? ( virtual/jpeg:0 )
	mp3? ( media-libs/libmad )
	mpeg2? ( media-libs/libmpeg2 )
	net? ( media-libs/sdl2-net )
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng:0 )
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

PATCHES=(
	"${FILESDIR}/${P}-tts_pthread_link.patch"
	"${FILESDIR}/${P}-fluidsynth.patch"
)

src_prepare() {
	xdg_src_prepare

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

	local myconf=(
		--backend=sdl
		--host=${CHOST}
		--enable-verbose-build
		--prefix="${EPREFIX}/usr"
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--opengl-mode=$(usex opengl auto none)
		$(use_enable a52)
		$(use_enable aac faad)
		$(use_enable alsa)
		$(use_enable debug)
		$(use_enable !debug release-mode)
		$(use_enable flac)
		$(usex fluidsynth '' --disable-fluidsynth)
		$(use_enable jpeg)
		$(use_enable lua)
		$(use_enable mp3 mad)
		$(use_enable mpeg2)
		$(use_enable net sdlnet)
		$(use_enable png)
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
	./configure "${myconf[@]}" "${EXTRA_ECONF}" || die
}

src_compile() {
	emake AR="$(tc-getAR) cru" RANLIB="$(tc-getRANLIB)"
}

src_install() {
	default
	doicon -s scalable icons/scummvm.svg
}
