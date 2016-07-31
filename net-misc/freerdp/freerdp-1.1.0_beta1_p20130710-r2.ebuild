# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit cmake-utils vcs-snapshot

if [[ ${PV} != 9999* ]]; then
	COMMIT="780d451afad21a22d2af6bd030ee71311856f038"
	SRC_URI="https://github.com/FreeRDP/FreeRDP/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~x86"
else
	inherit git-2
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/FreeRDP/FreeRDP.git
		https://github.com/FreeRDP/FreeRDP.git"
	KEYWORDS=""
fi

DESCRIPTION="Free implementation of the Remote Desktop Protocol"
HOMEPAGE="http://www.freerdp.com/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="alsa +client cups debug directfb doc ffmpeg gstreamer jpeg
	pulseaudio server smartcard cpu_flags_x86_sse2 test usb X xinerama xv"

RDEPEND="
	dev-libs/openssl:0
	sys-libs/zlib
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
	directfb? ( dev-libs/DirectFB )
	ffmpeg? ( virtual/ffmpeg )
	gstreamer? (
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-base:0.10
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
	X? (
		x11-libs/libX11
		x11-libs/libxkbfile
	)
"
DEPEND="${RDEPEND}
	<dev-util/cmake-3.1
	virtual/pkgconfig
	client? ( X? ( doc? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/xmlto
	) ) )
"

DOCS=( README )

PATCHES=(
	"${FILESDIR}/${P}-ffmpeg.patch"
	"${FILESDIR}/${PN}-1.1-CVE-2014-0250.patch"
	"${FILESDIR}/${P}-uclibc.patch"
	"${FILESDIR}/${P}-cmake.patch"
)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with alsa ALSA)
		$(cmake-utils_use_with client CLIENT)
		$(cmake-utils_use_with cups CUPS)
		$(cmake-utils_use_with debug DEBUG_ALL)
		$(cmake-utils_use_with doc MANPAGES)
		$(cmake-utils_use_with directfb DIRECTFB)
		$(cmake-utils_use_with ffmpeg FFMPEG)
		$(cmake-utils_use_with gstreamer GSTREAMER)
		$(cmake-utils_use_with jpeg JPEG)
		$(cmake-utils_use_with pulseaudio PULSE)
		$(cmake-utils_use_with server SERVER)
		$(cmake-utils_use_with smartcard PCSC)
		$(cmake-utils_use_with cpu_flags_x86_sse2 SSE2)
		$(cmake-utils_use usb CHANNEL_URBDRC)
		$(cmake-utils_use_with X X11)
		$(cmake-utils_use_with xinerama XINERAMA)
		$(cmake-utils_use_with xv XV)
		$(cmake-utils_use_build test TESTING)
	)
	cmake-utils_src_configure
}
