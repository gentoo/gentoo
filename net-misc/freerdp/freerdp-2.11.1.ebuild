# Copyright 2011-2023 Gentoo Authors
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
	MY_P=${P/_/-}
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://pub.freerdp.com/releases/${MY_P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"
fi

DESCRIPTION="Free implementation of the Remote Desktop Protocol"
HOMEPAGE="https://www.freerdp.com/"

LICENSE="Apache-2.0"
SLOT="0/2"
IUSE="alsa cpu_flags_arm_neon cups debug doc +ffmpeg gstreamer icu jpeg kerberos openh264 pulseaudio server smartcard systemd test usb valgrind wayland X xinerama xv"
RESTRICT="!test? ( test )"

RDEPEND="
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
		x11-libs/libXrandr
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
	wayland? (
		dev-libs/wayland
		x11-libs/libxkbcommon
	)
	X? (
		x11-libs/libX11
		x11-libs/libxkbfile
	)
"
DEPEND="
	${RDEPEND}
	valgrind? ( dev-util/valgrind )
"
BDEPEND="
	virtual/pkgconfig
	X? ( doc? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/xmlto
	) )
"

PATCHES=(
	"${FILESDIR}/freerdp-2.11.2-clang.patch"
	"${FILESDIR}/freerdp-2.11-Revert-codec-encode-messages-considering-endianness.patch"
)

src_configure() {
	# bug #881695
	filter-lto

	local mycmakeargs=(
		-Wno-dev
		-DBUILD_TESTING=$(usex test ON OFF)
		-DCHANNEL_URBDRC=$(usex usb ON OFF)
		-DWITH_ALSA=$(usex alsa ON OFF)
		-DWITH_CCACHE=OFF
		-DWITH_CUPS=$(usex cups ON OFF)
		-DWITH_DEBUG_ALL=$(usex debug ON OFF)
		-DWITH_MANPAGES=$(usex doc ON OFF)
		-DWITH_FFMPEG=$(usex ffmpeg ON OFF)
		-DWITH_SWSCALE=$(usex ffmpeg ON OFF)
		-DWITH_CAIRO=$(usex ffmpeg OFF ON)
		-DWITH_DSP_FFMPEG=$(usex ffmpeg ON OFF)
		-DWITH_GSTREAMER_1_0=$(usex gstreamer ON OFF)
		-DWITH_ICU=$(usex icu ON OFF)
		-DWITH_JPEG=$(usex jpeg ON OFF)
		-DWITH_GSSAPI=$(usex kerberos ON OFF)
		-DWITH_NEON=$(usex cpu_flags_arm_neon ON OFF)
		-DWITH_OPENH264=$(usex openh264 ON OFF)
		-DWITH_OSS=OFF
		-DWITH_PULSE=$(usex pulseaudio ON OFF)
		-DWITH_SERVER=$(usex server ON OFF)
		-DWITH_PCSC=$(usex smartcard ON OFF)
		-DWITH_LIBSYSTEMD=$(usex systemd ON OFF)
		-DWITH_VALGRIND_MEMCHECK=$(usex valgrind ON OFF)
		-DWITH_X11=$(usex X ON OFF)
		-DWITH_XINERAMA=$(usex xinerama ON OFF)
		-DWITH_XV=$(usex xv ON OFF)
		-DWITH_WAYLAND=$(usex wayland ON OFF)
	)
	cmake_src_configure
}

src_test() {
	local myctestargs=()
	use elibc_musl && myctestargs+=( -E TestBacktrace )
	cmake_src_test
}
