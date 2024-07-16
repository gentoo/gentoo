# Copyright 2011-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/FreeRDP/FreeRDP.git"
	case ${PV} in
		2.*) EGIT_BRANCH="stable-2.0";;
	esac
else
	inherit verify-sig
	MY_P=${P/_/-}
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://pub.freerdp.com/releases/${MY_P}.tar.gz
		verify-sig? ( https://pub.freerdp.com/releases/${MY_P}.tar.gz.asc )"
	KEYWORDS="~alpha amd64 arm arm64 ~loong ppc ppc64 ~riscv ~x86"
	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-akallabeth )"
	VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/akallabeth.asc"
fi

DESCRIPTION="Free implementation of the Remote Desktop Protocol"
HOMEPAGE="https://www.freerdp.com/"

LICENSE="Apache-2.0"
SLOT="2"
IUSE="alsa cpu_flags_arm_neon client cups debug +ffmpeg gstreamer icu jpeg kerberos openh264 pulseaudio server smartcard systemd test usb valgrind wayland X xinerama xv"
RESTRICT="!test? ( test )"

BDEPEND+="
	virtual/pkgconfig
	app-text/docbook-xml-dtd:4.1.2
	app-text/xmlto
"

COMMON_DEPEND="
	dev-libs/openssl:0=
	sys-libs/zlib:0
	alsa? ( media-libs/alsa-lib )
	cups? ( net-print/cups )
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
	ffmpeg? ( media-video/ffmpeg:0= )
	!ffmpeg? (
		x11-libs/cairo:0=
	)
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		X? ( x11-libs/libXrandr )
	)
	icu? ( dev-libs/icu:0= )
	jpeg? ( media-libs/libjpeg-turbo:0= )
	kerberos? ( virtual/krb5 )
	openh264? ( media-libs/openh264:0= )
	pulseaudio? ( media-libs/libpulse )
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
	client? (
		wayland? (
			dev-libs/wayland
			x11-libs/libxkbcommon
		)
	)
	X? (
		x11-libs/libX11
		x11-libs/libxkbfile
	)
"
DEPEND="${COMMON_DEPEND}
	valgrind? ( dev-debug/valgrind )
"
RDEPEND="${COMMON_DEPEND}
	!net-misc/freerdp:0
	client? ( !net-misc/freerdp:3[client] )
	server? ( !net-misc/freerdp:3[server] )
"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}/freerdp-2.11.2-clang.patch"
		"${FILESDIR}/freerdp-2.11-Revert-codec-encode-messages-considering-endianness.patch"
		"${FILESDIR}/freerdp-2.11.7-type-mismatch.patch"
	)
	cmake_src_prepare
}

option() {
	usex "$1" ON OFF
}

option_client() {
	if use client; then
		option "$1"
	else
		echo OFF
	fi
}

src_configure() {
	# bug #881695
	filter-lto

	# https://bugs.gentoo.org/927731
	append-cflags $(test-flags-CC -Wno-error=incompatible-pointer-types)

	local mycmakeargs=(
		-Wno-dev
		-DBUILD_TESTING=$(option test)
		-DCHANNEL_URBDRC=$(option usb)
		-DWITH_ALSA=$(option alsa)
		-DWITH_CCACHE=OFF
		-DWITH_CUPS=$(option cups)
		-DWITH_CLIENT=$(option client)
		-DWITH_DEBUG_ALL=$(option debug)
		-DWITH_MANPAGES=ON
		-DWITH_FFMPEG=$(option ffmpeg)
		-DWITH_SWSCALE=$(option ffmpeg)
		-DWITH_CAIRO=$(option !ffmpeg)
		-DWITH_DSP_FFMPEG=$(option ffmpeg)
		-DWITH_GSTREAMER_1_0=$(option gstreamer)
		-DWITH_ICU=$(option icu)
		-DWITH_JPEG=$(option jpeg)
		-DWITH_GSSAPI=$(option kerberos)
		-DWITH_NEON=$(option cpu_flags_arm_neon)
		-DWITH_OPENH264=$(option openh264)
		-DWITH_OSS=OFF
		-DWITH_PULSE=$(option pulseaudio)
		-DWITH_SERVER=$(option server)
		-DWITH_PCSC=$(option smartcard)
		-DWITH_LIBSYSTEMD=$(option systemd)
		-DWITH_VALGRIND_MEMCHECK=$(option valgrind)
		-DWITH_X11=$(option X)
		-DWITH_XINERAMA=$(option xinerama)
		-DWITH_XV=$(option xv)
		-DWITH_WAYLAND=$(option_client wayland)
		-DWITH_WINPR_TOOLS=$(option server)
	)
	cmake_src_configure
}

src_test() {
	local myctestargs=( -E TestBacktrace )
	cmake_src_test
}

src_install() {
	cmake_src_install
	mv "${ED}"/usr/share/man/man7/wlog{,2}.7 || die
}
