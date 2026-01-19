# Copyright 2011-2026 Gentoo Authors
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
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-akallabeth )"
	VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/akallabeth.asc"
fi

DESCRIPTION="Free implementation of the Remote Desktop Protocol"
HOMEPAGE="https://www.freerdp.com/"

LICENSE="Apache-2.0"
SLOT="3"
IUSE="aad alsa cpu_flags_arm_neon +client cups debug +ffmpeg +fuse gstreamer +icu jpeg kerberos openh264 pulseaudio sdl server smartcard systemd test usb valgrind wayland X xinerama xv"
RESTRICT="!test? ( test )"

BDEPEND+="
	virtual/pkgconfig
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
"
COMMON_DEPEND="
	dev-libs/openssl:0=
	virtual/zlib:=
	aad? ( dev-libs/cJSON )
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
	fuse? ( sys-fs/fuse:3= )
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
		sdl? (
			media-libs/libsdl3
			media-libs/sdl3-ttf
		)
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
	client? ( !net-misc/freerdp:2[client] )
	server? ( !net-misc/freerdp:2[server] )
	smartcard? ( app-crypt/p11-kit )
"

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

run_for_testing() {
	if use test; then
		local BUILD_DIR="${WORKDIR}/${P}_testing"
		"$@"
	fi
}

src_configure() {
	use debug || append-cppflags -DNDEBUG
	freerdp_configure -DBUILD_TESTING=OFF
	run_for_testing freerdp_configure -DBUILD_TESTING=ON
}

freerdp_configure() {
	local mycmakeargs=(
		-Wno-dev

		# https://bugs.gentoo.org/927037
		-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=OFF

		-DCHANNEL_URBDRC=$(option usb)
		-DWITH_AAD=$(option aad)
		-DWITH_ALSA=$(option alsa)
		-DWITH_CCACHE=OFF

		-DWITH_CLIENT=$(option client)
		-DWITH_CLIENT_SDL2=OFF
		-DWITH_CLIENT_SDL3=$(option_client sdl)

		-DWITH_SAMPLE=OFF
		-DWITH_CUPS=$(option cups)
		-DWITH_DEBUG_ALL=$(option debug)
		-DWITH_VERBOSE_WINPR_ASSERT=$(option debug)
		-DWITH_MANPAGES=ON
		-DWITH_FFMPEG=$(option ffmpeg)
		-DWITH_FREERDP_DEPRECATED_COMMANDLINE=ON
		-DWITH_SWSCALE=$(option ffmpeg)
		-DWITH_CAIRO=$(option !ffmpeg)
		-DWITH_DSP_FFMPEG=$(option ffmpeg)
		-DWITH_FUSE=$(option fuse)
		-DWITH_GSTREAMER_1_0=$(option gstreamer)
		-DWITH_JPEG=$(option jpeg)
		-DWITH_KRB5=$(option kerberos)
		-DWITH_NEON=$(option cpu_flags_arm_neon)
		-DWITH_OPENH264=$(option openh264)
		-DWITH_OSS=OFF
		-DWITH_PCSC=$(option smartcard)
		-DWITH_PKCS11=$(option smartcard)
		-DWITH_PULSE=$(option pulseaudio)
		-DWITH_SERVER=$(option server)
		-DWITH_LIBSYSTEMD=$(option systemd)
		-DWITH_UNICODE_BUILTIN=$(option !icu)
		-DWITH_VALGRIND_MEMCHECK=$(option valgrind)
		-DWITH_X11=$(option X)
		-DWITH_XINERAMA=$(option xinerama)
		-DWITH_XV=$(option xv)
		-DWITH_WAYLAND=$(option_client wayland)
		-DWITH_WEBVIEW=OFF
		-DWITH_WINPR_TOOLS=$(option server)

		"$@"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	run_for_testing cmake_src_compile
}

src_test() {
	# TestBacktrace: bug 930636
	# TestSynchCritical, TestSynchMultipleThreads: bug 951301
	local CMAKE_SKIP_TESTS=( TestBacktrace TestSynchCritical TestSynchMultipleThreads )
	if has network-sandbox ${FEATURES}; then
		CMAKE_SKIP_TESTS+=( TestConnect )
	fi
	run_for_testing cmake_src_test
}

src_install() {
	cmake_src_install
	mv "${ED}"/usr/share/man/man7/wlog{,3}.7 || die
}
