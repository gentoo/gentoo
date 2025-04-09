# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs xdg

DESCRIPTION="Implementation of the MPEG-4 Systems standard developed from scratch in ANSI C"
HOMEPAGE="https://gpac.wp.imt.fr/"
SRC_URI="https://github.com/gpac/gpac/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/12"
KEYWORDS="~alpha amd64 ~ppc ppc64 sparc x86"
IUSE="
	X a52 aac alsa dvb ffmpeg http2 jack jpeg jpeg2k libcaca lzma mad
	opengl png pulseaudio sdl ssl theora truetype vorbis xvid
"

RDEPEND="
	sys-libs/zlib:=
	X? (
		x11-libs/libX11
		x11-libs/libXv
		x11-libs/libXext
	)
	a52? ( media-libs/a52dec )
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( media-video/ffmpeg:= )
	http2? ( net-libs/nghttp2:= )
	jack? ( virtual/jack )
	jpeg2k? ( media-libs/openjpeg:2= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	libcaca? ( media-libs/libcaca )
	lzma? ( app-arch/xz-utils )
	mad? ( media-libs/libmad )
	opengl? (
		media-libs/libglvnd[X]
		x11-libs/libX11
		virtual/glu
	)
	png? ( media-libs/libpng:= )
	pulseaudio? ( media-libs/libpulse )
	sdl? ( media-libs/libsdl2 )
	ssl? ( dev-libs/openssl:= )
	theora? (
		media-libs/libogg
		media-libs/libtheora
	)
	truetype? ( media-libs/freetype )
	vorbis? ( media-libs/libvorbis )
	xvid? ( media-libs/xvid )
"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )
	dvb? ( sys-kernel/linux-headers )
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-configure-stddef.patch
	"${FILESDIR}"/${P}-ffmpeg6.patch
	"${FILESDIR}"/${P}-ffmpeg7.patch
)

src_prepare() {
	default

	# respect *FLAGS
	sed -e '/^sseflags=/d' -e 's/-O[0-3] //' -i configure || die

	# some configure options are ignored? (check if still needed on bump)
	use alsa || sed -i 's/^check_has_lib alsa/:/' configure || die
	use jack || sed -i 's/^check_has_lib jack/:/' configure || die
	use lzma || sed -i 's/^check_has_lib lzma/:/' configure || die
	use pulseaudio || sed -i 's/^check_has_lib pulseaudio/:/' configure || die
	use sdl || sed -i 's/has_sdl=.*/has_sdl=no/' configure || die
}

src_configure() {
	tc-export AR CC CXX RANLIB

	gpac_use() {
		usex ${1} --use-${2:-${1}}={system,no}
	}

	local conf=(
		./configure # not autotools-based

		--prefix="${EPREFIX}"/usr
		--libdir="$(get_libdir)"
		--extra-cflags="${CFLAGS}"
		--enable-pic
		--verbose

		$(use_enable X x11)
		$(use_enable dvb dvbx)
		$(use_enable opengl 3d)

		$(gpac_use a52)
		$(gpac_use alsa)
		$(gpac_use dvb dvb4linux)
		$(gpac_use aac faad)
		$(gpac_use ffmpeg)
		$(gpac_use truetype freetype)
		--use-hid=no # only for a deprecated module
		$(gpac_use jack)
		$(gpac_use jpeg)
		$(gpac_use libcaca)
		$(gpac_use lzma)
		$(gpac_use mad)
		$(gpac_use http2 nghttp2)
		$(gpac_use jpeg2k openjpeg)
		$(gpac_use png)
		$(gpac_use pulseaudio)
		$(gpac_use sdl)
		$(gpac_use ssl)
		$(gpac_use vorbis)
		$(gpac_use theora)
		$(gpac_use xvid)

		# not packaged
		--use-caption=no
		--use-directfb=no
		--use-freenect=no
		--use-mpeghdec=no
		--use-openhevc=no
		--use-opensvc=no
	)

	einfo "${conf[*]}"
	"${conf[@]}" || die
}

src_install() {
	emake STRIP=: DESTDIR="${D}" install
	dodoc Changelog README.md share/doc/{*.{bt,doc,txt},SceneGenerators}

	find "${ED}" -type f -name '*.a' -delete || die
}
