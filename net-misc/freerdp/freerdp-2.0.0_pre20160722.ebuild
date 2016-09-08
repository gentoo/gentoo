# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit cmake-utils

if [[ ${PV} != 9999 ]]; then
	COMMIT="5b2455f3147aca395a441fc65b602938600f0788"
	SRC_URI="https://github.com/FreeRDP/FreeRDP/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~x86"
	S="${WORKDIR}/FreeRDP-${COMMIT}"
else
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/FreeRDP/FreeRDP.git
		https://github.com/FreeRDP/FreeRDP.git"
fi

DESCRIPTION="Free implementation of the Remote Desktop Protocol"
HOMEPAGE="http://www.freerdp.com/"

LICENSE="Apache-2.0"
SLOT="0/2"
IUSE="alsa +client cpu_flags_x86_sse2 cups debug doc ffmpeg gstreamer jpeg libressl neon pulseaudio server smartcard systemd test usb wayland X xinerama xv"

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
	ffmpeg? ( virtual/ffmpeg )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		x11-libs/libXrandr
	)
	jpeg? ( virtual/jpeg:0 )
	pulseaudio? ( media-sound/pulseaudio )
	server? (
		X? (
			x11-libs/libXcursor
			x11-libs/libXdamage
			x11-libs/libXext
			x11-libs/libXfixes
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

DOCS=( README )

src_configure() {
	local mycmakeargs=(
		-DWITH_ALSA=$(usex alsa)
		-DWITH_CLIENT=$(usex client)
		-DWITH_CUPS=$(usex cups)
		-DWITH_DEBUG_ALL=$(usex debug)
		-DWITH_MANPAGES=$(usex doc)
		-DWITH_FFMPEG=$(usex ffmpeg)
		-DWITH_GSTREAMER_1_0=$(usex gstreamer)
		-DWITH_JPEG=$(usex jpeg)
		-DWITH_NEON=$(usex neon)
		-DWITH_PULSE=$(usex pulseaudio)
		-DWITH_SERVER=$(usex server)
		-DWITH_PCSC=$(usex smartcard)
		-DWITH_LIBSYSTEMD=$(usex systemd)
		-DWITH_SSE2=$(usex cpu_flags_x86_sse2)
		-DCHANNEL_URBDRC=$(usex usb)
		-DWITH_X11=$(usex X)
		-DWITH_XINERAMA=$(usex xinerama)
		-DWITH_XV=$(usex xv)
		-DBUILD_TESTING=$(usex test)
		-DWITH_WAYLAND=$(usex wayland)
	)
	cmake-utils_src_configure
}
