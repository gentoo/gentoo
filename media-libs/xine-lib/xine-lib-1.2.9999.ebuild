# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic libtool multilib

if [[ ${PV} == *9999* ]]; then
	EHG_REPO_URI="http://hg.debian.org/hg/xine-lib/xine-lib-1.2"
	inherit autotools mercurial eutils
	unset NLS_IUSE
	NLS_DEPEND="sys-devel/gettext"
	NLS_RDEPEND="virtual/libintl"
else
	KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd"
	SRC_URI="mirror://sourceforge/xine/${P}.tar.xz"
	NLS_IUSE="nls"
	NLS_DEPEND="nls? ( sys-devel/gettext )"
	NLS_RDEPEND="nls? ( virtual/libintl )"
fi

DESCRIPTION="Core libraries for Xine movie player"
HOMEPAGE="http://xine.sourceforge.net/"

LICENSE="GPL-2"
SLOT="1"
IUSE="a52 aac aalib +alsa altivec bluray +css directfb dts dvb dxr3 fbcon flac fusion gtk imagemagick ipv6 jack jpeg libav libcaca mad +mmap mng modplug musepack opengl oss pulseaudio samba sdl speex theora truetype v4l vaapi vcd vdpau vdr vidix +vis vorbis vpx wavpack +X +xcb xinerama +xv xvmc ${NLS_IUSE}"

RDEPEND="${NLS_RDEPEND}
	dev-libs/libxdg-basedir
	media-libs/libdvdnav
	sys-libs/zlib
	!libav? ( media-video/ffmpeg:0= )
	libav? (
		media-libs/libpostproc:0=
		media-video/libav:0=
	)
	virtual/libiconv
	a52? ( media-libs/a52dec )
	aac? ( media-libs/faad2 )
	aalib? ( media-libs/aalib )
	alsa? ( media-libs/alsa-lib )
	bluray? ( >=media-libs/libbluray-0.2.1 )
	css? ( >=media-libs/libdvdcss-1.2.10 )
	directfb? ( dev-libs/DirectFB )
	dts? ( media-libs/libdca )
	dxr3? ( media-libs/libfame )
	flac? ( media-libs/flac )
	fusion? ( media-libs/FusionSound )
	gtk? ( x11-libs/gdk-pixbuf:2 )
	imagemagick? ( || ( media-gfx/imagemagick media-gfx/graphicsmagick ) )
	jack? ( >=media-sound/jack-audio-connection-kit-0.100 )
	jpeg? ( virtual/jpeg:0 )
	libcaca? ( media-libs/libcaca )
	mad? ( media-libs/libmad )
	mng? ( media-libs/libmng )
	modplug? ( >=media-libs/libmodplug-0.8.8.1 )
	musepack? ( >=media-sound/musepack-tools-444 )
	opengl? (
		virtual/glu
		virtual/opengl
		)
	pulseaudio? ( media-sound/pulseaudio )
	samba? ( net-fs/samba )
	sdl? ( media-libs/libsdl )
	speex? (
		media-libs/libogg
		media-libs/speex
		)
	theora? (
		media-libs/libogg
		media-libs/libtheora
		)
	truetype? (
		media-libs/fontconfig
		media-libs/freetype:2
		)
	v4l? ( media-libs/libv4l )
	vaapi? ( x11-libs/libva )
	vcd? (
		>=media-video/vcdimager-0.7.23
		dev-libs/libcdio[-minimal]
		)
	vdpau? ( x11-libs/libvdpau )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
		)
	vpx? ( media-libs/libvpx:0= )
	wavpack? ( media-sound/wavpack )
	X? (
		x11-libs/libX11
		x11-libs/libXext
		)
	xcb? ( x11-libs/libxcb )
	xinerama? ( x11-libs/libXinerama )
	xv? ( x11-libs/libXv )
	xvmc? ( x11-libs/libXvMC )"
DEPEND="${RDEPEND}
	${NLS_DEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
	>=sys-devel/libtool-2.2.6b
	oss? ( virtual/os-headers )
	v4l? ( virtual/os-headers )
	X? (
		x11-libs/libXt
		x11-proto/xf86vidmodeproto
		x11-proto/xproto
		)
	xv? ( x11-proto/videoproto )
	xvmc? ( x11-proto/videoproto )
	xinerama? ( x11-proto/xineramaproto )"
REQUIRED_USE="vidix? ( || ( X fbcon ) )
	xv? ( X )
	xinerama? ( X )"

src_prepare() {
	default

	sed -i -e '/define VDR_ABS_FIFO_DIR/s|".*"|"/var/vdr/xine"|' src/vdr/input_vdr.c || die

	if [[ ${PV} == *9999* ]]; then
		epatch_user
		eautoreconf
	else
		elibtoolize
	fi

	local x
	for x in 0 1 2 3; do
		sed -i -e "/^O${x}_CFLAGS=\"-O${x}\"/d" configure || die
	done
}

src_configure() {
	[[ ${CHOST} == i?86-* ]] && append-flags -fomit-frame-pointer #422519

	local win32dir #197236
	if has_multilib_profile; then
		win32dir=/usr/$(ABI="x86" get_libdir)/win32
	else
		win32dir=/usr/$(get_libdir)/win32
	fi

	local myconf=()
	[[ ${PV} == *9999* ]] || myconf=( $(use_enable nls) )

	if ! use libav && has_version '>=media-video/ffmpeg-2.2:0'; then
		myconf+=( --enable-avformat ) #507474
	fi

	econf \
		$(use_enable ipv6) \
		$(use_enable altivec) \
		$(use_enable vis) \
		--disable-optimizations \
		$(use_enable mmap) \
		$(use_enable oss) \
		$(use_enable aalib) \
		$(use_enable directfb) \
		$(use_enable dxr3) \
		$(use_enable fbcon fb) \
		$(use_enable opengl) $(use_enable opengl glu) \
		$(use_enable vidix) \
		$(use_enable xinerama) \
		$(use_enable xvmc) \
		$(use_enable vdpau) \
		$(use_enable vaapi) \
		$(use_enable dvb) \
		--disable-gnomevfs \
		$(use_enable samba) \
		--disable-v4l $(use_enable v4l v4l2) $(use_enable v4l libv4l) \
		$(use_enable vcd) \
		$(use_enable vdr) \
		$(use_enable bluray) \
		$(use_enable a52 a52dec) \
		$(use_enable aac faad) \
		$(use_enable gtk gdkpixbuf) \
		$(use_enable jpeg libjpeg) \
		$(use_enable dts) \
		$(use_enable mad) \
		$(use_enable modplug) \
		$(use_enable musepack) \
		$(use_enable mng) \
		--disable-real-codecs \
		--disable-w32dll \
		$(use_enable vpx) \
		$(use_with truetype freetype) $(use_with truetype fontconfig) \
		$(use_with X x) \
		$(use_with alsa) \
		--without-esound \
		$(use_with fusion fusionsound) \
		$(use_with jack) \
		$(use_with pulseaudio) \
		$(use_with libcaca caca) \
		$(use_with sdl) \
		$(use_with xcb) \
		--with-xv-path=/usr/$(get_libdir) \
		$(use_with imagemagick) \
		--with-external-dvdnav \
		$(use_with flac libflac) \
		$(use_with speex) \
		$(use_with theora) \
		$(use_with vorbis) \
		--with-real-codecs-path=/usr/$(get_libdir)/codecs \
		--with-w32-path=${win32dir} \
		$(use_with wavpack) \
		"${myconf[@]}"
}

src_compile() {
	# enable verbose building, bug #448140
	emake V=1
}

src_install() {
	emake \
		DESTDIR="${D}" \
		docdir="/usr/share/doc/${PF}" \
		htmldir="/usr/share/doc/${PF}/html" \
		install

	rm -f \
		"${ED}"usr/lib*/libxine*.la \
		"${ED}"usr/share/doc/${PF}/COPYING
}
