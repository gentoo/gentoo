# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_REMOVE_MODULES_LIST=( FindFreetype )
LUA_COMPAT=( luajit )
PYTHON_COMPAT=( python3_{8..10} )

inherit cmake lua-single python-single-r1 xdg

OBS_BROWSER_COMMIT="b798763ae75b538e405c2d7e2ab3a1edfe59ed0c"
CEF_DIR="cef_binary_4638_linux64"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/obsproject/obs-studio.git"
	EGIT_SUBMODULES=( plugins/obs-browser )
else
	SRC_URI="https://github.com/obsproject/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI+=" browser? ( https://github.com/obsproject/obs-browser/archive/${OBS_BROWSER_COMMIT}.tar.gz -> obs-browser-${OBS_BROWSER_COMMIT}.tar.gz )"
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
	dev-qt/qtgui:5[wayland?]
	dev-qt/qtnetwork:5
	dev-qt/qtquickcontrols:5
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
	pulseaudio? ( media-sound/pulseaudio )
	python? ( ${PYTHON_DEPS} )
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
	elif use browser; then
		rm -d ${P}/plugins/obs-browser || die
		mv obs-browser-${OBS_BROWSER_COMMIT} ${P}/plugins/obs-browser || die
	fi
}

src_prepare() {
	# We have not enabled VST before, but now it will be looked for unconditionally if
	# any plugins are enabled, so make the VST part a warning instead of fatal for now.
	sed -i 's/FATAL_ERROR "obs-vst submodule not available/WARNING "obs-vst submodule not available/' \
		plugins/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		$(usev browser -DCEF_ROOT_DIR=../${CEF_DIR})
		-DENABLE_ALSA=$(usex alsa)
		-DENABLE_AJA=OFF
		-DENABLE_BROWSER=$(usex browser)
		-DENABLE_DECKLINK=$(usex decklink)
		-DENABLE_FREETYPE=$(usex truetype)
		-DENABLE_JACK=$(usex jack)
		-DENABLE_LIBFDK=$(usex fdk)
		-DENABLE_PIPEWIRE=$(usex pipewire)
		-DENABLE_PULSEAUDIO=$(usex pulseaudio)
		-DENABLE_RTMPS=$(usex ssl ON OFF)
		-DENABLE_SPEEXDSP=$(usex speex)
		-DENABLE_V4L2=$(usex v4l)
		-DENABLE_VLC=$(usex vlc)
		-DENABLE_WAYLAND=$(usex wayland)
		-DOBS_MULTIARCH_SUFFIX=${libdir#lib}
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
