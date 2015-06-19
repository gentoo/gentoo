# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/transcode/transcode-1.1.7-r1.ebuild,v 1.13 2015/02/17 01:19:00 vapier Exp $

EAPI=4
inherit eutils libtool multilib

DESCRIPTION="A suite of utilities for transcoding video and audio codecs in different containers"
HOMEPAGE="http://www.transcoding.org/ https://bitbucket.org/france/transcode-tcforge"
SRC_URI="https://www.bitbucket.org/france/${PN}-tcforge/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE="cpu_flags_x86_3dnow a52 aac alsa altivec dv dvd +iconv imagemagick jpeg lzo mjpeg cpu_flags_x86_mmx mp3 mpeg nuv ogg oss pic postproc quicktime sdl cpu_flags_x86_sse cpu_flags_x86_sse2 theora truetype v4l vorbis X x264 xml xvid"

RDEPEND="
	>=virtual/ffmpeg-0.10
	a52? ( media-libs/a52dec )
	aac? ( media-libs/faac )
	alsa? ( media-libs/alsa-lib )
	dv? ( media-libs/libdv )
	dvd? ( media-libs/libdvdread )
	iconv? ( virtual/libiconv )
	imagemagick? ( media-gfx/imagemagick )
	jpeg? ( virtual/jpeg )
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
	x264? ( media-libs/x264 )
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

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-ffmpeg.patch \
		"${FILESDIR}"/${P}-ffmpeg-0.10.patch \
		"${FILESDIR}"/${P}-ffmpeg-0.11.patch \
		"${FILESDIR}"/${P}-preset-free.patch

	elibtoolize
}

src_configure() {
	local myconf
	use x86 && myconf="$(use_enable !pic x86-textrels)" #271476

	econf \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable cpu_flags_x86_3dnow 3dnow) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable altivec) \
		$(use_enable v4l libv4l2) \
		$(use_enable v4l libv4lconvert) \
		$(use_enable mpeg libmpeg2) \
		$(use_enable mpeg libmpeg2convert) \
		--enable-experimental \
		--enable-deprecated \
		$(use_enable v4l) \
		$(use_enable oss) \
		$(use_enable alsa) \
		$(use_enable postproc libpostproc) \
		$(use_enable truetype freetype2) \
		$(use_enable mp3 lame) \
		$(use_enable xvid) \
		$(use_enable x264) \
		$(use_enable ogg) \
		$(use_enable vorbis) \
		$(use_enable theora) \
		$(use_enable dvd libdvdread) \
		$(use_enable dv libdv) \
		$(use_enable quicktime libquicktime) \
		$(use_enable lzo) \
		$(use_enable a52) \
		$(use_enable aac faac) \
		$(use_enable xml libxml2) \
		$(use_enable mjpeg mjpegtools) \
		$(use_enable sdl) \
		$(use_enable imagemagick) \
		$(use_enable jpeg libjpeg) \
		$(use_enable iconv) \
		$(use_enable nuv) \
		$(use_with X x) \
		--with-mod-path=/usr/$(get_libdir)/transcode \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" docsdir=/usr/share/doc/${PF} install
	dodoc AUTHORS ChangeLog README STYLE TODO
	find "${ED}"usr -name '*.la' -exec rm -f {} +
}
