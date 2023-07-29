# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_REMOVE_MODULES_LIST=( FindFreetype )
LUA_COMPAT=( luajit )
PYTHON_COMPAT=( python3_{9..12} )

inherit cmake lua-single optfeature python-single-r1 xdg

CEF_DIR="cef_binary_5060_linux64"
OBS_BROWSER_COMMIT="594115a27d40f0916e55db97cb61f7c7130cbe28"
OBS_WEBSOCKET_COMMIT="6fd18a7ef1ecb149e8444154af1daab61d4241a9"
QR_COMMIT="8518684c0f33d004fa93971be2c6a8eca3167d1e"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/obsproject/obs-studio.git"
	EGIT_SUBMODULES=(
		plugins/obs-browser
		plugins/obs-websocket
		plugins/obs-websocket/deps/asio
		plugins/obs-websocket/deps/json
		plugins/obs-websocket/deps/qr
		plugins/obs-websocket/deps/websocketpp
	)
else
	SRC_URI="
		https://github.com/obsproject/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/obsproject/obs-browser/archive/${OBS_BROWSER_COMMIT}.tar.gz -> obs-browser-${OBS_BROWSER_COMMIT}.tar.gz
		https://github.com/nayuki/QR-Code-generator/archive/${QR_COMMIT}.tar.gz -> qr-${QR_COMMIT}.tar.gz
		https://github.com/obsproject/obs-websocket/archive/${OBS_WEBSOCKET_COMMIT}.tar.gz -> obs-websocket-${OBS_WEBSOCKET_COMMIT}.tar.gz
	"
	KEYWORDS="~amd64 ~ppc64 ~x86"
fi
SRC_URI+=" browser? ( https://cdn-fastly.obsproject.com/downloads/${CEF_DIR}.tar.bz2 )"

DESCRIPTION="Software for Recording and Streaming Live Video Content"
HOMEPAGE="https://obsproject.com"

LICENSE="Boost-1.0 GPL-2+ MIT Unlicense"
SLOT="0"
IUSE="
	+alsa browser decklink fdk jack lua nvenc pipewire pulseaudio
	python qt6 speex +ssl truetype v4l vlc wayland websocket
"
REQUIRED_USE="
	browser? ( || ( alsa pulseaudio ) )
	lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )
"

BDEPEND="
	lua? ( dev-lang/swig )
	python? ( dev-lang/swig )
"
# media-video/ffmpeg[opus] required due to bug 909566
DEPEND="
	dev-libs/glib:2
	dev-libs/jansson:=
	media-libs/libglvnd
	media-libs/libva
	media-libs/x264:=
	media-video/ffmpeg:=[nvenc?,opus,x264]
	net-misc/curl
	sys-apps/dbus
	sys-apps/pciutils
	sys-apps/util-linux
	sys-libs/zlib:=
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXfixes
	x11-libs/libxcb:=
	alsa? ( media-libs/alsa-lib )
	browser? (
		|| (
			>=app-accessibility/at-spi2-core-2.46.0:2
			( app-accessibility/at-spi2-atk dev-libs/atk )
		)
		dev-libs/expat
		dev-libs/glib
		dev-libs/nspr
		dev-libs/nss
		dev-libs/wayland
		media-libs/alsa-lib
		media-libs/fontconfig
		media-libs/mesa[gbm(+)]
		net-print/cups
		x11-libs/cairo
		x11-libs/libdrm
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
	pipewire? ( media-video/pipewire:= )
	pulseaudio? ( media-libs/libpulse )
	python? ( ${PYTHON_DEPS} )
	qt6? (
		dev-qt/qtbase:6[network,widgets,xml(+)]
		dev-qt/qtsvg:6
		x11-libs/libxkbcommon
	)
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5[wayland?]
		dev-qt/qtnetwork:5
		dev-qt/qtquickcontrols:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
	speex? ( media-libs/speexdsp )
	ssl? ( net-libs/mbedtls:= )
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
		dev-cpp/asio
		dev-cpp/nlohmann_json
		dev-cpp/websocketpp
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

		rm -d ${P}/plugins/obs-websocket/deps/qr || die
		mv QR-Code-generator-${QR_COMMIT} ${P}/plugins/obs-websocket/deps/qr || die
	fi
}

src_prepare() {
	default

	sed -i '/-Werror$/d' "${WORKDIR}"/${P}/cmake/Modules/CompilerConfig.cmake || die

	cmake_src_prepare
}

src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		$(usev browser -DCEF_ROOT_DIR=../${CEF_DIR})
		-DCALM_DEPRECATION=ON
		-DCCACHE_SUPPORT=OFF
		-DENABLE_ALSA=$(usex alsa)
		-DENABLE_AJA=OFF
		-DENABLE_BROWSER=$(usex browser)
		-DENABLE_DECKLINK=$(usex decklink)
		-DENABLE_FREETYPE=$(usex truetype)
		-DENABLE_JACK=$(usex jack)
		-DENABLE_LIBFDK=$(usex fdk)
		-DENABLE_NEW_MPEGTS_OUTPUT=OFF # Requires librist and libsrt.
		-DENABLE_PIPEWIRE=$(usex pipewire)
		-DENABLE_PULSEAUDIO=$(usex pulseaudio)
		-DENABLE_RTMPS=$(usex ssl ON OFF) # Needed for bug 880861
		-DENABLE_SPEEXDSP=$(usex speex)
		-DENABLE_V4L2=$(usex v4l)
		-DENABLE_VLC=$(usex vlc)
		-DENABLE_VST=ON
		-DENABLE_WAYLAND=$(usex wayland)
		-DENABLE_WEBSOCKET=$(usex websocket)
		-DOBS_MULTIARCH_SUFFIX=${libdir#lib}
		-DQT_VERSION=$(usex qt6 6 5)
		-DUNIX_STRUCTURE=1
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

	if use browser && use ssl; then
		mycmakeargs+=( -DENABLE_WHATSNEW=ON )
	else
		mycmakeargs+=( -DENABLE_WHATSNEW=OFF )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# external plugins may need some things not installed by default, install them here
	insinto /usr/include/obs/UI/obs-frontend-api
	doins UI/obs-frontend-api/obs-frontend-api.h
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
