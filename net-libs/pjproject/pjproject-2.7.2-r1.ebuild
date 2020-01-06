# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic

DESCRIPTION="Open source SIP, Media, and NAT Traversal Library"
HOMEPAGE="https://www.pjsip.org/"
SRC_URI="https://www.pjsip.org/release/${PV}/${P}.tar.bz2"
KEYWORDS="~amd64 ~ppc ~x86"

LICENSE="GPL-2"
SLOT="0"
CODEC_FLAGS="g711 g722 g7221 gsm ilbc speex l16"
VIDEO_FLAGS="sdl ffmpeg v4l2 openh264 libyuv"
SOUND_FLAGS="alsa oss portaudio"
IUSE="amr debug doc epoll examples ipv6 libressl opus resample silk ssl static-libs webrtc ${CODEC_FLAGS} ${VIDEO_FLAGS} ${SOUND_FLAGS}"

PATCHES=(
	"${FILESDIR}"/${P}-ssl-flipflop.patch
	"${FILESDIR}"/${P}-libressl.patch
)

RDEPEND="alsa? ( media-libs/alsa-lib )
	oss? ( media-libs/portaudio[oss] )
	portaudio? ( media-libs/portaudio )

	amr? ( media-libs/opencore-amr )
	gsm? ( media-sound/gsm )
	ilbc? ( media-libs/libilbc )
	opus? ( media-libs/opus )
	speex? ( media-libs/speexdsp )

	ffmpeg? ( virtual/ffmpeg:= )
	sdl? ( media-libs/libsdl )
	openh264? ( media-libs/openh264 )
	resample? ( media-libs/libsamplerate )

	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)

	net-libs/libsrtp:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	!!media-plugins/mediastreamer-bcg729"

REQUIRED_USE="?? ( ${SOUND_FLAGS} )"

src_prepare() {
	default
	rm configure || die "Unable to remove unwanted wrapper"
	mv aconfigure.ac configure.ac || die "Unable to rename configure script source"
	eautoreconf
}

src_configure() {
	local myconf=()
	local videnable="--disable-video"
	local t

	use ipv6 && append-cflags -DPJ_HAS_IPV6=1
	use debug || append-cflags -DNDEBUG=1

	for t in ${CODEC_FLAGS}; do
		myconf+=( $(use_enable ${t} ${t}-codec) )
	done

	for t in ${VIDEO_FLAGS}; do
		myconf+=( $(use_enable ${t}) )
		use "${t}" && videnable="--enable-video"
	done

	econf \
		--enable-shared \
		--with-external-srtp \
		${videnable} \
		$(use_enable epoll) \
		$(use_with gsm external-gsm) \
		$(use_with speex external-speex) \
		$(use_enable speex speex-aec) \
		$(use_enable resample) \
		$(use_enable resample libsamplerate) \
		$(use_enable resample resample-dll) \
		$(use_enable alsa sound) \
		$(use_enable oss) \
		$(use_with portaudio external-pa) \
		$(use_enable portaudio ext-sound) \
		$(use_enable amr opencore-amr) \
		$(use_enable silk) \
		$(use_enable opus) \
		$(use_enable ssl) \
		$(use_enable webrtc libwebrtc) \
		"${myconf[@]}"
}

src_compile() {
	emake dep
	emake
}

src_install() {
	emake DESTDIR="${D}" install

	if use doc; then
		dodoc README.txt README-RTEMS
	fi

	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		doins -r pjsip-apps/src/samples
	fi

	use static-libs || rm "${D}/usr/$(get_libdir)/*.a"
}
