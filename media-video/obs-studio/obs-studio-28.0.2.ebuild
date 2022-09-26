# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_REMOVE_MODULES_LIST=( FindFreetype )
LUA_COMPAT=( luajit )
PYTHON_COMPAT=( python3_{8..10} )

inherit cmake lua-single python-single-r1 xdg

OBS_BROWSER_COMMIT="d1fa35dcbc384136e9e883f2d6071b14fd8f9a65"
OBS_WEBSOCKET_COMMIT="265899f76f88a5be74747308fff3d35347ce43c5"
ASIO_COMMIT="b73dc1d2c0ecb9452a87c26544d7f71e24342df6"
JSON_COMMIT="a34e011e24beece3b69397a03fdc650546f052c3"
QR_COMMIT="8518684c0f33d004fa93971be2c6a8eca3167d1e"
WEBSOCKETPP_COMMIT="56123c87598f8b1dd471be83ca841ceae07f95ba"

CEF_DIR="cef_binary_4638_linux64"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/obsproject/obs-studio.git"
	EGIT_SUBMODULES=( plugins/obs-browser plugins/obs-websocket )
else
	SRC_URI="https://github.com/obsproject/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI+=" browser? ( https://github.com/obsproject/obs-browser/archive/${OBS_BROWSER_COMMIT}.tar.gz -> obs-browser-${OBS_BROWSER_COMMIT}.tar.gz )"
	SRC_URI+=" https://github.com/obsproject/obs-websocket/archive/${OBS_WEBSOCKET_COMMIT}.tar.gz -> obs-websocket-${OBS_WEBSOCKET_COMMIT}.tar.gz "
	SRC_URI+=" https://github.com/chriskohlhoff/asio/archive/${ASIO_COMMIT}.tar.gz -> asio-${ASIO_COMMIT}.tar.gz "
	SRC_URI+=" https://github.com/nlohmann/json/archive/${JSON_COMMIT}.tar.gz -> json-${JSON_COMMIT}.tar.gz "
	SRC_URI+=" https://github.com/nayuki/QR-Code-generator/archive/${QR_COMMIT}.tar.gz -> qr-${QR_COMMIT}.tar.gz "
	SRC_URI+=" https://github.com/zaphoyd/websocketpp/archive/${WEBSOCKETPP_COMMIT}.tar.gz -> websocketpp-${WEBSOCKETPP_COMMIT}.tar.gz "
	KEYWORDS="~amd64 ~ppc64 ~x86"
fi
SRC_URI+=" browser? ( https://cdn-fastly.obsproject.com/downloads/${CEF_DIR}.tar.bz2 )"

DESCRIPTION="Software for Recording and Streaming Live Video Content"
HOMEPAGE="https://obsproject.com"

LICENSE="GPL-2"
SLOT="0"
IUSE="
	+alsa browser decklink fdk jack lua nvenc pipewire
	pulseaudio python speex +ssl truetype v4l vlc wayland
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
DEPEND="
	dev-libs/glib:2
	dev-libs/jansson:=
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5[wayland?]
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/libglvnd
	media-libs/x264:=
	media-video/ffmpeg:=[nvenc?,x264]
	net-misc/curl
	sys-apps/dbus
	sys-apps/pciutils
	sys-libs/zlib:=
	virtual/udev
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXfixes
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libxcb:=
	alsa? ( media-libs/alsa-lib )
	browser? (
		app-accessibility/at-spi2-atk
		app-accessibility/at-spi2-core:2
		dev-libs/atk
		dev-libs/expat
		dev-libs/glib
		dev-libs/nspr
		dev-libs/nss
		media-libs/alsa-lib
		media-libs/fontconfig
		media-libs/mesa[gbm(+)]
		net-print/cups
		x11-libs/cairo
		x11-libs/libdrm
		x11-libs/libXScrnSaver
		x11-libs/libXcursor
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrender
		x11-libs/libXtst
	)
	fdk? ( media-libs/fdk-aac:= )
	jack? ( virtual/jack )
	lua? ( ${LUA_DEPS} )
	pipewire? ( media-video/pipewire:= )
	pulseaudio? ( media-sound/pulseaudio )
	python? ( ${PYTHON_DEPS} )
	speex? ( media-libs/speexdsp )
	ssl? ( net-libs/mbedtls:= )
	truetype? (
		media-libs/fontconfig
		media-libs/freetype
	)
	v4l? ( media-libs/libv4l )
	vlc? ( media-video/vlc:= )
	wayland? ( dev-libs/wayland )
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
		if use browser; then
			rm -d ${P}/plugins/obs-browser || die
			mv obs-browser-${OBS_BROWSER_COMMIT} ${P}/plugins/obs-browser || die
		fi

		rm -d ${P}/plugins/obs-websocket || die
		mv obs-websocket-${OBS_WEBSOCKET_COMMIT} ${P}/plugins/obs-websocket || die

		rm -d ${P}/plugins/obs-websocket/deps/asio || die
		mv asio-${ASIO_COMMIT} ${P}/plugins/obs-websocket/deps/asio || die

		rm -d ${P}/plugins/obs-websocket/deps/json || die
		mv json-${JSON_COMMIT} ${P}/plugins/obs-websocket/deps/json || die

		rm -d ${P}/plugins/obs-websocket/deps/qr || die
		mv QR-Code-generator-${QR_COMMIT} ${P}/plugins/obs-websocket/deps/qr || die

		rm -d ${P}/plugins/obs-websocket/deps/websocketpp || die
		mv websocketpp-${WEBSOCKETPP_COMMIT} ${P}/plugins/obs-websocket/deps/websocketpp || die
	fi
}

src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		$(usev browser -DCEF_ROOT_DIR=../${CEF_DIR})
		-DBUILD_BROWSER=$(usex browser)
		-DBUILD_VST=no
		-DENABLE_WAYLAND=$(usex wayland)
		-DENABLE_AJA=OFF
		-DENABLE_ALSA=$(usex alsa)
		-DENABLE_DECKLINK=$(usex decklink)
		-DENABLE_FREETYPE=$(usex truetype)
		-DENABLE_JACK=$(usex jack)
		-DENABLE_LIBFDK=$(usex fdk)
		-DENABLE_NEW_MPEGTS_OUTPUT=OFF
		-DENABLE_PIPEWIRE=$(usex pipewire)
		-DENABLE_PULSEAUDIO=$(usex pulseaudio)
		-DENABLE_SPEEXDSP=$(usex speex)
		-DENABLE_V4L2=$(usex v4l)
		-DENABLE_VLC=$(usex vlc)
		-DOBS_MULTIARCH_SUFFIX=${libdir#lib}
		-DUNIX_STRUCTURE=1
		-DWITH_RTMPS=$(usex ssl)

		# deprecated and currently cause issues
		# https://github.com/obsproject/obs-studio/pull/4560#issuecomment-826345608
		-DLIBOBS_PREFER_IMAGEMAGICK=no
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
			-DENABLE_SCRIPTING=yes
		)
	else
		mycmakeargs+=( -DENABLE_SCRIPTING=no )
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
		elog "either the 'alsa' or the 'pulseaudio' USE-flag needs to"
		elog "be enabled."
		elog
	fi
}
