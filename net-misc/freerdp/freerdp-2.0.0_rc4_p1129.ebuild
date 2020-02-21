# Copyright 2011-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} != 9999 ]]; then
	COMMIT="483d09b760bea529972afad9b6f6c7a89dcffd40"
	SRC_URI="https://github.com/FreeRDP/FreeRDP/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/FreeRDP-${COMMIT}"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/FreeRDP/FreeRDP.git"
fi

DESCRIPTION="Free implementation of the Remote Desktop Protocol"
HOMEPAGE="http://www.freerdp.com/"

LICENSE="Apache-2.0"
SLOT="0/2"
IUSE="alsa +client cpu_flags_arm_neon cups debug doc +ffmpeg gstreamer jpeg libav libressl openh264 pulseaudio server smartcard systemd test usb wayland X xinerama xv"
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
	!ffmpeg? (
		x11-libs/cairo:0=
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

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test ON OFF)
		-DCHANNEL_URBDRC=$(usex usb ON OFF)
		-DWITH_ALSA=$(usex alsa ON OFF)
		-DWITH_CCACHE=OFF
		-DWITH_CLIENT=$(usex client ON OFF)
		-DWITH_CUPS=$(usex cups ON OFF)
		-DWITH_DEBUG_ALL=$(usex debug ON OFF)
		-DWITH_MANPAGES=$(usex doc ON OFF)
		-DWITH_FFMPEG=$(usex ffmpeg ON OFF)
		-DWITH_SWSCALE=$(usex ffmpeg ON OFF)
		-DWITH_CAIRO=$(usex ffmpeg OFF ON)
		-DWITH_DSP_FFMPEG=$(usex ffmpeg ON OFF)
		-DWITH_GSTREAMER_1_0=$(usex gstreamer ON OFF)
		-DWITH_JPEG=$(usex jpeg ON OFF)
		-DWITH_NEON=$(usex cpu_flags_arm_neon ON OFF)
		-DWITH_OPENH264=$(usex openh264 ON OFF)
		-DWITH_PULSE=$(usex pulseaudio ON OFF)
		-DWITH_SERVER=$(usex server ON OFF)
		-DWITH_PCSC=$(usex smartcard ON OFF)
		-DWITH_LIBSYSTEMD=$(usex systemd ON OFF)
		-DWITH_X11=$(usex X ON OFF)
		-DWITH_XINERAMA=$(usex xinerama ON OFF)
		-DWITH_XV=$(usex xv ON OFF)
		-DWITH_WAYLAND=$(usex wayland ON OFF)
	)
	cmake_src_configure
}
