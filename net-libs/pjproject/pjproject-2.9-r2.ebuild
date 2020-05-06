# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="Open source SIP, Media, and NAT Traversal Library"
HOMEPAGE="https://www.pjsip.org/"
SRC_URI="https://www.pjsip.org/release/${PV}/${P}.tar.bz2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

LICENSE="GPL-2"
SLOT="0"

# g729 not included due to special bcg729 handling.
CODEC_FLAGS="g711 g722 g7221 gsm ilbc speex l16"
VIDEO_FLAGS="sdl ffmpeg v4l2 openh264 libyuv"
SOUND_FLAGS="alsa portaudio"
IUSE="amr debug epoll examples ipv6 libressl opus resample silk ssl static-libs webrtc
	${CODEC_FLAGS} g729
	${VIDEO_FLAGS}
	${SOUND_FLAGS}"

PATCHES=(
	"${FILESDIR}/pjproject-2.9-ssl-enable.patch"
)

RDEPEND="net-libs/libsrtp:=

	alsa? ( media-libs/alsa-lib )
	amr? ( media-libs/opencore-amr )
	ffmpeg? ( media-video/ffmpeg:= )
	g729? ( media-libs/bcg729 )
	gsm? ( media-sound/gsm )
	ilbc? ( media-libs/libilbc )
	openh264? ( media-libs/openh264 )
	opus? ( media-libs/opus )
	portaudio? ( media-libs/portaudio )
	resample? ( media-libs/libsamplerate )
	sdl? ( media-libs/libsdl )
	speex? ( media-libs/speexdsp )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	rm configure || die "Unable to remove unwanted wrapper"
	mv aconfigure.ac configure.ac || die "Unable to rename configure script source"
	eautoreconf

	cp "${FILESDIR}/pjproject-2.9-config_site.h" "${S}/pjlib/include/pj/config_site.h" || die "Unable to create config_site.h"
}

src_configure() {
	local myconf=()
	local videnable="--disable-video"
	local t

	use debug || append-cflags -DNDEBUG=1
	use ipv6 && append-cflags -DPJ_HAS_IPV6=1
	append-cflags -DPJMEDIA_HAS_SRTP=1

	for t in ${CODEC_FLAGS}; do
		myconf+=( $(use_enable ${t} ${t}-codec) )
	done
	myconf+=( $(use_enable g729 bcg729) )

	for t in ${VIDEO_FLAGS}; do
		myconf+=( $(use_enable ${t}) )
		use "${t}" && videnable="--enable-video"
	done

	[ "${videnable}" = "--enable-video" ] && append-cflags -DPJMEDIA_HAS_VIDEO=1

	econf \
		--enable-shared \
		--with-external-srtp \
		${videnable} \
		$(use_enable alsa sound) \
		$(use_enable amr opencore-amr) \
		$(use_enable epoll) \
		$(use_enable opus) \
		$(use_enable portaudio ext-sound) \
		$(use_enable resample libsamplerate) \
		$(use_enable resample resample-dll) \
		$(use_enable resample) \
		$(use_enable silk) \
		$(use_enable speex speex-aec) \
		$(use_enable ssl) \
		$(use_with gsm external-gsm) \
		$(use_with portaudio external-pa) \
		$(use_with speex external-speex) \
		$(usex webrtc '' --disable-libwebrtc) \
		"${myconf[@]}"
}

src_compile() {
	emake dep
	emake
}

src_install() {
	default

	newbin pjsip-apps/bin/pjsua-${CHOST} pjsua
	newbin pjsip-apps/bin/pjsystest-${CHOST} pjsystest

	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		doins -r pjsip-apps/src/samples
	fi

	use static-libs || rm "${ED}/usr/$(get_libdir)"/*.a || die "Error removing static archives"
}
