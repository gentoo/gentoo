# Copyright 2011-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

if [[ ${PV} != 9999 ]]; then
	MY_P=${P/_/-}
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://pub.freerdp.com/releases/${MY_P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~x86"
else
	inherit git-r3
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
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	client? ( X? ( doc? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/xmlto
	) ) )
"

usex-on-off() {
	usex "$1" ON OFF
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex-on-off test)
		-DCHANNEL_URBDRC=$(usex-on-off usb)
		-DWITH_ALSA=$(usex-on-off alsa)
		-DWITH_CCACHE=OFF
		-DWITH_CLIENT=$(usex-on-off client)
		-DWITH_CUPS=$(usex-on-off cups)
		-DWITH_DEBUG_ALL=$(usex-on-off debug)
		-DWITH_MANPAGES=$(usex-on-off doc)
		-DWITH_FFMPEG=$(usex-on-off ffmpeg)
		-DWITH_DSP_FFMPEG=$(usex-on-off ffmpeg)
		-DWITH_GSTREAMER_1_0=$(usex-on-off gstreamer)
		-DWITH_JPEG=$(usex-on-off jpeg)
		-DWITH_NEON=$(usex-on-off cpu_flags_arm_neon)
		-DWITH_OPENH264=$(usex-on-off openh264)
		-DWITH_PULSE=$(usex-on-off pulseaudio)
		-DWITH_SERVER=$(usex-on-off server)
		-DWITH_PCSC=$(usex-on-off smartcard)
		-DWITH_LIBSYSTEMD=$(usex-on-off systemd)
		-DWITH_X11=$(usex-on-off X)
		-DWITH_XINERAMA=$(usex-on-off xinerama)
		-DWITH_XV=$(usex-on-off xv)
		-DWITH_WAYLAND=$(usex-on-off wayland)
	)
	cmake-utils_src_configure
}
