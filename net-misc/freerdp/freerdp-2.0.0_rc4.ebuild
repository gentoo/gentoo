# Copyright 2011-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils

if [[ ${PV} != 9999 ]]; then
	MY_P=${P/_/-}
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://pub.freerdp.com/releases/${MY_P}.tar.gz
		https://github.com/FreeRDP/FreeRDP/commit/6931f54fad12eaf46a72c5c02ac05da817ab6b94.patch -> freerdp-2.0.0-rc4-fix-NTLM-AvPair-lists.patch"
	KEYWORDS="alpha amd64 arm arm64 ppc ppc64 x86"
else
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/FreeRDP/FreeRDP.git"
fi

DESCRIPTION="Free implementation of the Remote Desktop Protocol"
HOMEPAGE="http://www.freerdp.com/"

LICENSE="Apache-2.0"
SLOT="0/2"
IUSE="alsa +client cpu_flags_arm_neon cups debug doc ffmpeg gstreamer jpeg libav libressl openh264 pulseaudio server smartcard systemd test usb wayland X xinerama xv"
RESTRICT="!test? ( test )"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	sys-libs/zlib:0
	alsa? ( media-libs/alsa-lib )
	cups? ( net-print/cups )
	client? (
		usb? (
			virtual/libudev:0=
			sys-apps/util-linux:0=
			dev-libs/dbus-glib:0=
			virtual/libusb:1=
		)
		X? (
			x11-libs/libXcursor
			x11-libs/libXext
			x11-libs/libXi
			x11-libs/libXrender
			xinerama? ( x11-libs/libXinerama )
			xv? ( x11-libs/libXv )
		)
	)
	ffmpeg? (
		libav? ( media-video/libav:0= )
		!libav? ( media-video/ffmpeg:0= )
	)
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		x11-libs/libXrandr
	)
	jpeg? ( virtual/jpeg:0 )
	openh264? ( media-libs/openh264 )
	pulseaudio? ( media-sound/pulseaudio )
	server? (
		X? (
			x11-libs/libXcursor
			x11-libs/libXdamage
			x11-libs/libXext
			x11-libs/libXfixes
			x11-libs/libXrandr
			x11-libs/libXtst
			xinerama? ( x11-libs/libXinerama )
		)
	)
	smartcard? ( sys-apps/pcsc-lite )
	systemd? ( sys-apps/systemd:0= )
	wayland? (
		dev-libs/wayland
		x11-libs/libxkbcommon
	)
	X? (
		x11-libs/libX11
		x11-libs/libxkbfile
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	client? ( X? ( doc? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/xmlto
	) ) )
"

PATCHES=(
	"${FILESDIR}"/2.0.0-rc4-libressl.patch
	"${FILESDIR}"/2.0.0-rc4-bitmap-endian.patch
	"${DISTDIR}"/freerdp-2.0.0-rc4-fix-NTLM-AvPair-lists.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DCHANNEL_URBDRC=$(usex usb)
		-DWITH_ALSA=$(usex alsa)
		-DWITH_CCACHE=OFF
		-DWITH_CLIENT=$(usex client)
		-DWITH_CUPS=$(usex cups)
		-DWITH_DEBUG_ALL=$(usex debug)
		-DWITH_MANPAGES=$(usex doc)
		-DWITH_FFMPEG=$(usex ffmpeg)
		-DWITH_DSP_FFMPEG=$(usex ffmpeg)
		-DWITH_GSTREAMER_1_0=$(usex gstreamer)
		-DWITH_JPEG=$(usex jpeg)
		-DWITH_NEON=$(usex cpu_flags_arm_neon)
		-DWITH_OPENH264=$(usex openh264)
		-DWITH_PULSE=$(usex pulseaudio)
		-DWITH_SERVER=$(usex server)
		-DWITH_PCSC=$(usex smartcard)
		-DWITH_LIBSYSTEMD=$(usex systemd)
		-DWITH_X11=$(usex X)
		-DWITH_XINERAMA=$(usex xinerama)
		-DWITH_XV=$(usex xv)
		-DWITH_WAYLAND=$(usex wayland)
	)
	cmake-utils_src_configure
}
