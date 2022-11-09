# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic libtool

if [[ ${PV} == *9999* ]]; then
	EHG_REPO_URI="http://hg.code.sf.net/p/xine/xine-lib-1.2"
	inherit autotools mercurial
	unset NLS_IUSE
	NLS_DEPEND="sys-devel/gettext"
	NLS_RDEPEND="virtual/libintl"
else
	KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86"
	SRC_URI="mirror://sourceforge/xine/${P}.tar.xz"
	NLS_IUSE="nls"
	NLS_DEPEND="nls? ( sys-devel/gettext )"
	NLS_RDEPEND="nls? ( virtual/libintl )"
fi

DESCRIPTION="Core libraries for Xine movie player"
HOMEPAGE="http://xine.sourceforge.net/"

LICENSE="GPL-2"
SLOT="1"
IUSE="a52 aac aalib +alsa bluray cpu_flags_ppc_altivec +css dav1d dts dvb dxr3 fbcon flac gtk imagemagick ipv6 jack jpeg libcaca mad +mmap mng modplug musepack nfs opengl oss pulseaudio samba sftp sdl speex theora truetype v4l vaapi vcd vdpau vdr vidix +vis vorbis vpx wavpack wayland +X xinerama +xv xvmc ${NLS_IUSE}"

BDEPEND="
	app-arch/xz-utils
	>=sys-devel/libtool-2.2.6b
	virtual/pkgconfig
"
RDEPEND="
	dev-libs/libxdg-basedir
	media-libs/libdvdnav
	media-video/ffmpeg:=
	sys-libs/zlib:=
	virtual/libiconv
	a52? ( media-libs/a52dec )
	aac? ( media-libs/faad2 )
	aalib? ( media-libs/aalib )
	alsa? ( media-libs/alsa-lib )
	bluray? ( >=media-libs/libbluray-0.2.1:= )
	css? ( >=media-libs/libdvdcss-1.2.10 )
	dav1d? ( media-libs/dav1d:= )
	dts? ( media-libs/libdca )
	dxr3? ( media-libs/libfame )
	flac? ( media-libs/flac:= )
	gtk? ( x11-libs/gdk-pixbuf:2 )
	imagemagick? ( virtual/imagemagick-tools )
	jack? ( virtual/jack )
	jpeg? ( media-libs/libjpeg-turbo:= )
	libcaca? ( media-libs/libcaca )
	mad? ( media-libs/libmad )
	mng? ( media-libs/libmng:= )
	modplug? ( >=media-libs/libmodplug-0.8.8.1 )
	musepack? ( >=media-sound/musepack-tools-444 )
	nfs? ( net-fs/libnfs:= )
	opengl? (
		virtual/glu
		virtual/opengl
	)
	pulseaudio? ( media-sound/pulseaudio )
	samba? ( net-fs/samba )
	sftp? ( net-libs/libssh2 )
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
	vaapi? ( media-libs/libva:=[X] )
	vcd? (
		>=media-video/vcdimager-0.7.23
		dev-libs/libcdio:=[-minimal]
	)
	vdpau? ( x11-libs/libvdpau )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	vpx? ( media-libs/libvpx:= )
	wavpack? ( media-sound/wavpack )
	wayland? ( dev-libs/wayland )
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libxcb:=
	)
	xinerama? ( x11-libs/libXinerama )
	xv? ( x11-libs/libXv )
	xvmc? ( x11-libs/libXvMC )
"
DEPEND="${RDEPEND}
	oss? ( virtual/os-headers )
	v4l? ( virtual/os-headers )
	X? (
		x11-base/xorg-proto
		x11-libs/libXt
	)
	xv? ( x11-base/xorg-proto )
	xvmc? ( x11-base/xorg-proto )
	xinerama? ( x11-base/xorg-proto )
"
REQUIRED_USE="
	vidix? ( || ( X fbcon ) )
	xv? ( X )
	xinerama? ( X )
"

src_prepare() {
	default

	sed -i -e '/define VDR_ABS_FIFO_DIR/s|".*"|"/var/vdr/xine"|' src/vdr/input_vdr.c || die

	if [[ "${PV}" = *9999* ]] ; then
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

	local myconf=(
		--disable-directfb
		--disable-gnomevfs
		--disable-optimizations
		--disable-real-codecs
		--disable-v4l
		--disable-w32dll
		--enable-avformat
		--with-external-dvdnav
		--with-real-codecs-path=/usr/$(get_libdir)/codecs
		--with-w32-path=${win32dir}
		--with-xv-path=/usr/$(get_libdir)
		--without-esound
		--without-fusionsound
		# Added dav1d for now. Could support both? Does it need to be XOR?
		--without-libaom
		$(use_enable a52 a52dec)
		$(use_enable aac faad)
		$(use_enable aalib)
		$(use_enable cpu_flags_ppc_altivec altivec)
		$(use_enable bluray)
		$(use_enable dts)
		$(use_enable dvb)
		$(use_enable dxr3)
		$(use_enable fbcon fb)
		$(use_enable gtk gdkpixbuf)
		$(use_enable ipv6)
		$(use_enable jpeg libjpeg)
		$(use_enable mad)
		$(use_enable mmap)
		$(use_enable mng)
		$(use_enable modplug)
		$(use_enable musepack)
		$(use_enable nfs)
		$(use_enable opengl)
		$(use_enable opengl glu)
		$(use_enable oss)
		$(use_enable samba)
		$(use_enable sftp)
		$(use_enable v4l libv4l)
		$(use_enable v4l v4l2)
		$(use_enable vaapi)
		$(use_enable vdpau)
		$(use_enable vis)
		$(use_enable vidix)
		$(use_enable xinerama)
		$(use_enable xvmc)
		$(use_enable vcd)
		$(use_enable vdr)
		$(use_enable vpx)
		$(use_enable wayland)
		$(use_with alsa)
		$(use_with dav1d)
		$(use_with flac libflac)
		$(use_with imagemagick)
		$(use_with jack)
		$(use_with libcaca caca)
		$(use_with pulseaudio)
		$(use_with sdl)
		$(use_with speex)
		$(use_with theora)
		$(use_with truetype fontconfig)
		$(use_with truetype freetype)
		$(use_with vorbis)
		$(use_with wavpack)
		$(use_with X x)
		$(use_with X xcb)
	)
	[[ ${PV} == *9999* ]] || myconf+=( $(use_enable nls) )

	econf "${myconf[@]}"
}

src_compile() {
	# enable verbose building, bug #448140
	emake V=1
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
	rm "${ED}"/usr/share/doc/${PF}/COPYING || die
}
