# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# TODO: Figure out a way to disable SRTP from pjproject entirely.
EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Open source SIP, Media, and NAT Traversal Library"
HOMEPAGE="https://www.pjsip.org/"
SRC_URI="https://github.com/pjsip/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"

LICENSE="GPL-2"
SLOT="0/${PV}"

# g729 not included due to special bcg729 handling.
CODEC_FLAGS="g711 g722 g7221 gsm ilbc speex l16"
VIDEO_FLAGS="sdl ffmpeg v4l2 openh264 libyuv vpx"
SOUND_FLAGS="alsa portaudio"
IUSE="amr debug epoll examples opus resample silk ssl static-libs webrtc
	${CODEC_FLAGS} g729
	${VIDEO_FLAGS}
	${SOUND_FLAGS}"

RDEPEND=">=net-libs/libsrtp-2.3.0:=
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
	speex? (
		media-libs/speex
		media-libs/speexdsp
	)
	ssl? (
		dev-libs/openssl:0=
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/pjproject-2.12.1-CVE-2022-31031.patch"
	"${FILESDIR}/pjproject-2.12.1-r2-CVE-2022-39244.patch" # 875863
	"${FILESDIR}/pjproject-2.12.1-r2-CVE-2022-39269.patch" # 875863
	"${FILESDIR}/pjproject-2.12.1-r2-bashism.patch" # 865719
	"${FILESDIR}/pjproject-2.12.1-r2-musl.patch" # 867343
)

src_prepare() {
	default
	rm configure || die "Unable to remove unwanted wrapper"
	mv aconfigure.ac configure.ac || die "Unable to rename configure script source"
	eautoreconf

	cp "${FILESDIR}/pjproject-2.12.1-config_site.h" "${S}/pjlib/include/pj/config_site.h" || die "Unable to create config_site.h"
}

_pj_enable() {
	usex "$1" '' "--disable-${2:-$1}"
}

_pj_get_define() {
	local r="$(sed -nre "s/^#define[[:space:]]+$1[[:space:]]+//p" "${S}/pjlib/include/pj/config_site.h")"
	[[ -z "${r}" ]] && die "Unable to fine #define $1 in config_site.h"
	echo "$r"
}

_pj_set_define() {
	local c=$(_pj_get_define "$1")
	[[ "$c" = "$2" ]] && return 0
	sed -re "s/^#define[[:space:]]+$1[[:space:]].*/#define $1 $2/" -i "${S}/pjlib/include/pj/config_site.h" || die "sed failed updating $1 to $2."
	[[ "$(_pj_get_define "$1")" != "$2" ]] && die "sed failed to perform update for $1 to $2."
}

_pj_use_set_define() {
	_pj_set_define "$2" $(usex "$1" 1 0)
}

src_configure() {
	local myconf=()
	local videnable="--disable-video"
	local t

	use debug || append-cflags -DNDEBUG=1

	for t in ${CODEC_FLAGS}; do
		myconf+=( $(_pj_enable ${t} ${t}-codec) )
	done
	myconf+=( $(_pj_enable g729 bcg729) )

	for t in ${VIDEO_FLAGS}; do
		myconf+=( $(_pj_enable ${t}) )
		use "${t}" && videnable="--enable-video"
	done

	[ "${videnable}" = "--enable-video" ] && _pj_set_define PJMEDIA_HAS_VIDEO 1 || _pj_set_define PJMEDIA_HAS_VIDEO 0

	LD="$(tc-getCC)" econf \
		--enable-shared \
		--with-external-srtp \
		${videnable} \
		$(_pj_enable alsa sound) \
		$(_pj_enable amr opencore-amr) \
		$(_pj_enable epoll) \
		$(_pj_enable opus) \
		$(_pj_enable portaudio ext-sound) \
		$(_pj_enable resample libsamplerate) \
		$(_pj_enable resample resample-dll) \
		$(_pj_enable resample) \
		$(_pj_enable silk) \
		$(_pj_enable speex speex-aec) \
		$(_pj_enable ssl) \
		$(_pj_enable webrtc libwebrtc) \
		$(use_with gsm external-gsm) \
		$(use_with portaudio external-pa) \
		$(use_with speex external-speex) \
		"${myconf[@]}"
}

src_compile() {
	emake dep LD="$(tc-getCC)"
	emake LD="$(tc-getCC)"
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
