# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_REMOVE_MODULES_LIST=( FindMbedTLS )
LUA_COMPAT=( luajit )
# For the time being upstream supports up to Python 3.12 only.
# Any issues found with 3.13+ should be reported as a Gentoo bug.
PYTHON_COMPAT=( python3_{11..14} )

inherit cmake flag-o-matic lua-single optfeature python-single-r1 xdg

CEF_AMD64="cef_binary_6533_linux_x86_64_v5"
CEF_ARM64="cef_binary_6533_linux_aarch64_v5"
OBS_BROWSER_COMMIT="bdabf8300ecefeb566b81f4a7ff75f8a8e21f62b"
OBS_WEBSOCKET_COMMIT="40d26dbf4d29137bf88cd393a3031adb04d68bba"

DESCRIPTION="Software for Recording and Streaming Live Video Content"
HOMEPAGE="https://obsproject.com"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/obsproject/obs-studio.git"
	EGIT_SUBMODULES=(
		plugins/obs-browser
		plugins/obs-websocket
	)
else
	SRC_URI="
		https://github.com/obsproject/${PN}/archive/${PV}.tar.gz
			-> ${P}.tar.gz
		https://github.com/obsproject/obs-browser/archive/${OBS_BROWSER_COMMIT}.tar.gz
			-> obs-browser-${OBS_BROWSER_COMMIT}.tar.gz
		https://github.com/obsproject/obs-websocket/archive/${OBS_WEBSOCKET_COMMIT}.tar.gz
			-> obs-websocket-${OBS_WEBSOCKET_COMMIT}.tar.gz
	"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

SRC_URI+="
	browser? (
		amd64? ( https://cdn-fastly.obsproject.com/downloads/${CEF_AMD64}.tar.xz )
		arm64? ( https://cdn-fastly.obsproject.com/downloads/${CEF_ARM64}.tar.xz )
	)
"

LICENSE="Boost-1.0 GPL-2+ MIT Unlicense"
SLOT="0"
IUSE="
	+alsa browser decklink fdk jack lua mpegts nvenc pipewire pulseaudio
	python qsv sndio speex test-input truetype v4l vlc wayland websocket
"
REQUIRED_USE="
	browser? ( || ( alsa pulseaudio ) )
	lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )
"

BDEPEND="
	kde-frameworks/extra-cmake-modules:0
	lua? ( dev-lang/swig )
	python? ( dev-lang/swig )
"
# media-video/ffmpeg[opus] required due to bug 909566
# The websocket plug-in fails to build with 'dev-cpp/asio-1.34.0':
#   https://github.com/obsproject/obs-websocket/issues/1291
DEPEND="
	dev-cpp/nlohmann_json
	dev-libs/glib:2
	dev-libs/jansson:=
	dev-libs/uthash
	dev-qt/qtbase:6[network,widgets,xml(+),X]
	dev-qt/qtsvg:6
	media-libs/libglvnd[X]
	media-libs/libva
	media-libs/rnnoise
	media-libs/x264:=
	>=media-video/ffmpeg-6.1:=[nvenc?,opus,x264]
	net-misc/curl
	net-libs/mbedtls:3=
	sys-apps/dbus
	sys-apps/pciutils
	sys-apps/util-linux
	sys-libs/zlib:=
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb:=
	x11-libs/libXcomposite
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	alsa? ( media-libs/alsa-lib )
	browser? (
		>=app-accessibility/at-spi2-core-2.46.0:2
		dev-libs/expat
		dev-libs/glib
		dev-libs/nspr
		dev-libs/nss
		media-libs/alsa-lib
		media-libs/fontconfig
		media-libs/mesa[gbm(+)]
		net-print/cups
		x11-libs/cairo
		x11-libs/libXcursor
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libxkbcommon
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libXScrnSaver
		x11-libs/libxshmfence
		x11-libs/libXtst
		x11-libs/pango
	)
	fdk? ( media-libs/fdk-aac:= )
	jack? ( virtual/jack )
	lua? ( ${LUA_DEPS} )
	mpegts? (
		net-libs/librist
		net-libs/srt
	)
	nvenc? ( >=media-libs/nv-codec-headers-12 )
	pipewire? ( media-video/pipewire:= )
	pulseaudio? ( media-libs/libpulse )
	python? ( ${PYTHON_DEPS} )
	qsv? ( media-libs/libvpl )
	sndio? ( media-sound/sndio )
	speex? ( media-libs/speexdsp )
	truetype? (
		media-libs/fontconfig
		media-libs/freetype
	)
	v4l? (
		media-libs/libv4l
		virtual/udev
	)
	vlc? ( media-video/vlc:= )
	wayland? (
		dev-libs/wayland
		x11-libs/libxkbcommon
	)
	websocket? (
		<dev-cpp/asio-1.34.0
		dev-cpp/websocketpp
		dev-libs/qr-code-generator
	)
"
RDEPEND="${DEPEND}"

QA_PREBUILT="
	usr/lib*/obs-plugins/chrome-sandbox
	usr/lib*/obs-plugins/libcef.so
	usr/lib*/obs-plugins/libEGL.so
	usr/lib*/obs-plugins/libGLESv2.so
	usr/lib*/obs-plugins/libvk_swiftshader.so
	usr/lib*/obs-plugins/libvulkan.so.1
	usr/lib*/obs-plugins/swiftshader/libEGL.so
	usr/lib*/obs-plugins/swiftshader/libGLESv2.so
"

pkg_setup() {
	use lua && lua-single_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_unpack() {
	default

	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	else
		rm -d ${P}/plugins/obs-browser || die
		mv obs-browser-${OBS_BROWSER_COMMIT} ${P}/plugins/obs-browser || die

		rm -d ${P}/plugins/obs-websocket || die
		mv obs-websocket-${OBS_WEBSOCKET_COMMIT} ${P}/plugins/obs-websocket || die
	fi
}

src_prepare() {
	default

	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/867250
	# https://github.com/obsproject/obs-studio/issues/8988
	use wayland && filter-lto

	cmake_src_prepare
}

src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DENABLE_ALSA=$(usex alsa)
		-DENABLE_AJA=OFF
		-DENABLE_BROWSER=$(usex browser)
		-DENABLE_CCACHE=OFF
		-DENABLE_DECKLINK=$(usex decklink)
		-DENABLE_FFMPEG_NVENC=$(usex nvenc)
		-DENABLE_FREETYPE=$(usex truetype)
		-DENABLE_JACK=$(usex jack)
		-DENABLE_LIBFDK=$(usex fdk)
		-DENABLE_NEW_MPEGTS_OUTPUT=$(usex mpegts)
		-DENABLE_NVENC=$(usex nvenc)
		-DENABLE_PIPEWIRE=$(usex pipewire)
		-DENABLE_PULSEAUDIO=$(usex pulseaudio)
		-DENABLE_QSV11=$(usex qsv)
		-DENABLE_RNNOISE=ON
		-DENABLE_SNDIO=$(usex sndio)
		-DENABLE_SPEEXDSP=$(usex speex)
		-DENABLE_TEST_INPUT=$(usex test-input)
		-DENABLE_V4L2=$(usex v4l)
		-DENABLE_VLC=$(usex vlc)
		-DENABLE_VST=ON
		-DENABLE_WAYLAND=$(usex wayland)
		-DENABLE_WEBRTC=OFF # Requires libdatachannel.
		-DENABLE_WEBSOCKET=$(usex websocket)
	)

	if [[ ${PV} != 9999 ]]; then
		mycmakeargs+=(
			-DOBS_VERSION_OVERRIDE=${PV}
		)
	fi

	if use lua || use python; then
		mycmakeargs+=(
			-DENABLE_SCRIPTING_LUA=$(usex lua)
			-DENABLE_SCRIPTING_PYTHON=$(usex python)
			-DENABLE_SCRIPTING=ON
		)
	else
		mycmakeargs+=( -DENABLE_SCRIPTING=OFF )
	fi

	if use browser; then
		use amd64 && mycmakeargs+=( -DCEF_ROOT_DIR=../cef_binary_6533_linux_x86_64 )
		use arm64 && mycmakeargs+=( -DCEF_ROOT_DIR=../cef_binary_6533_linux_aarch64 )
		mycmakeargs+=( -DENABLE_WHATSNEW=ON )
	else
		mycmakeargs+=( -DENABLE_WHATSNEW=OFF )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# external plugins may need some things not installed by default, install them here
	insinto /usr/include/obs/frontend/api
	doins frontend/api/obs-frontend-api.h
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! use alsa && ! use pulseaudio; then
		elog
		elog "For the audio capture features to be available,"
		elog "at least one of the 'alsa' or 'pulseaudio' USE-flags needs to"
		elog "be enabled."
		elog
	fi

	if use v4l && has_version media-video/v4l2loopback; then
		elog
		elog "Depending on system configuration, the v4l2loopback kernel module"
		elog "may need to be loaded manually, and needs to be re-built after"
		elog "kernel changes."
		elog
	fi

	optfeature "VA-API hardware encoding" media-video/ffmpeg[vaapi]
	optfeature "virtual camera support" media-video/v4l2loopback
}
