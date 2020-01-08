# Copyright 2002-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools libtool multilib

DESCRIPTION="A suite of utilities for transcoding video and audio codecs in different containers"
HOMEPAGE="http://www.transcoding.org/ https://bitbucket.org/france/transcode-tcforge"
SRC_URI="https://www.bitbucket.org/france/${PN}-tcforge/downloads/${P}.tar.bz2
	https://dev.gentoo.org/~mgorny/dist/${P}-patchset.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm64 ppc ppc64 sparc x86"
IUSE="cpu_flags_x86_3dnow a52 aac alsa altivec dv dvd +iconv imagemagick jpeg lzo mjpeg cpu_flags_x86_mmx mp3 mpeg nuv ogg oss pic postproc quicktime sdl cpu_flags_x86_sse cpu_flags_x86_sse2 theora truetype v4l vorbis X x264 xml xvid"

RDEPEND="
	>=virtual/ffmpeg-0.10
	a52? ( media-libs/a52dec )
	aac? ( media-libs/faac )
	alsa? ( media-libs/alsa-lib )
	dv? ( media-libs/libdv )
	dvd? ( media-libs/libdvdread:0= )
	iconv? ( virtual/libiconv )
	imagemagick? ( media-gfx/imagemagick:= )
	jpeg? ( virtual/jpeg:0= )
	lzo? ( >=dev-libs/lzo-2 )
	mjpeg? ( media-video/mjpegtools )
	mp3? ( media-sound/lame )
	mpeg? ( media-libs/libmpeg2 )
	ogg? ( media-libs/libogg )
	postproc? ( >=virtual/ffmpeg-0.10 )
	quicktime? ( >=media-libs/libquicktime-1 )
	sdl? ( >=media-libs/libsdl-1.2.5[X?] )
	theora? ( media-libs/libtheora )
	truetype? ( >=media-libs/freetype-2 )
	v4l? ( media-libs/libv4l )
	vorbis? ( media-libs/libvorbis )
	X? ( x11-libs/libXpm x11-libs/libXaw x11-libs/libXv )
	x264? ( media-libs/x264:= )
	xml? ( dev-libs/libxml2 )
	xvid? ( media-libs/xvid )
	"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	v4l? ( >=sys-kernel/linux-headers-2.6.11 )
	"

REQUIRED_USE="
	cpu_flags_x86_sse? ( cpu_flags_x86_mmx )
	cpu_flags_x86_sse2? ( cpu_flags_x86_mmx cpu_flags_x86_sse )
	cpu_flags_x86_3dnow? ( cpu_flags_x86_mmx )
	nuv? ( lzo )
	"

PATCHES=(
	"${WORKDIR}"/${P}-patchset/${P}-ffmpeg.patch
	"${WORKDIR}"/${P}-patchset/${P}-ffmpeg-0.10.patch
	"${WORKDIR}"/${P}-patchset/${P}-ffmpeg-0.11.patch
	"${WORKDIR}"/${P}-patchset/${P}-preset-free.patch
	"${WORKDIR}"/${P}-patchset/${P}-libav-9.patch
	"${WORKDIR}"/${P}-patchset/${P}-libav-10.patch
	"${WORKDIR}"/${P}-patchset/${P}-preset-force.patch
	"${WORKDIR}"/${P}-patchset/${P}-ffmpeg2.patch
	"${WORKDIR}"/${P}-patchset/${P}-freetype251.patch
	"${WORKDIR}"/${P}-patchset/${P}-ffmpeg24.patch
)

src_prepare() {
	if has_version '>=media-video/ffmpeg-2.8' ||
		has_version '>=media-video/libav-12'; then
		PATCHES+=( "${WORKDIR}"/${P}-patchset/${P}-ffmpeg29.patch )
	fi

	if has_version '>=media-gfx/imagemagick-7.0.1.0' ; then
		PATCHES+=( "${WORKDIR}"/${P}-patchset/${P}-imagemagick7.patch )
	fi

	if has_version '>=media-video/ffmpeg-4' ;  then
		PATCHES+=( "${FILESDIR}/ffmpeg4.patch" )
	fi

	default

	eautoreconf
}

src_configure() {
	local myconf
	use x86 && myconf="$(use_enable !pic x86-textrels)" #271476

	local myeconfargs=(
		$(use_enable cpu_flags_x86_mmx mmx)
		$(use_enable cpu_flags_x86_3dnow 3dnow)
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_enable altivec)
		$(use_enable v4l libv4l2)
		$(use_enable v4l libv4lconvert)
		$(use_enable mpeg libmpeg2)
		$(use_enable mpeg libmpeg2convert)
		--enable-experimental
		--enable-deprecated
		$(use_enable v4l)
		$(use_enable oss)
		$(use_enable alsa)
		$(use_enable postproc libpostproc)
		$(use_enable truetype freetype2)
		$(use_enable mp3 lame)
		$(use_enable xvid)
		$(use_enable x264)
		$(use_enable ogg)
		$(use_enable vorbis)
		$(use_enable theora)
		$(use_enable dvd libdvdread)
		$(use_enable dv libdv)
		$(use_enable quicktime libquicktime)
		$(use_enable lzo)
		$(use_enable a52)
		$(use_enable aac faac)
		$(use_enable xml libxml2)
		$(use_enable mjpeg mjpegtools)
		$(use_enable sdl)
		$(use_enable imagemagick)
		$(use_enable jpeg libjpeg)
		$(use_enable iconv)
		$(use_enable nuv)
		$(use_with X x)
		--with-mod-path=/usr/$(get_libdir)/transcode
		${myconf}
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" docsdir=/usr/share/doc/${PF} install
	dodoc AUTHORS ChangeLog README STYLE TODO
	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
