# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 qt5-build

DESCRIPTION="Library for rendering dynamic web content in Qt5 C++ and QML applications"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

IUSE="bindist geolocation +system-ffmpeg +system-icu widgets"

RDEPEND="
	app-arch/snappy
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	~dev-qt/qtcore-${PV}
	~dev-qt/qtdeclarative-${PV}
	~dev-qt/qtgui-${PV}
	~dev-qt/qtnetwork-${PV}
	~dev-qt/qtwebchannel-${PV}[qml]
	dev-libs/expat
	dev-libs/jsoncpp:=
	dev-libs/libevent:=
	dev-libs/libxml2
	dev-libs/libxslt
	media-libs/alsa-lib
	media-libs/flac
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=
	media-libs/libpng:0=
	>=media-libs/libvpx-1.5:=[svc]
	media-libs/libwebp:=
	media-libs/mesa
	media-libs/opus
	media-libs/speex
	net-libs/libsrtp:=
	sys-apps/dbus
	sys-apps/pciutils
	sys-libs/libcap
	sys-libs/zlib[minizip]
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	geolocation? ( ~dev-qt/qtpositioning-${PV} )
	system-ffmpeg? ( media-video/ffmpeg:0= )
	system-icu? ( dev-libs/icu:= )
	widgets? ( ~dev-qt/qtwidgets-${PV} )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-util/gperf
	dev-util/ninja
	dev-util/re2c
	sys-devel/bison
"

src_prepare() {
	qt_use_disable_mod geolocation positioning \
		src/core/core_common.pri \
		src/core/core_gyp_generator.pro

	qt_use_disable_mod widgets widgets src/src.pro

	qt5-build_src_prepare
}

src_configure() {
	export NINJA_PATH=/usr/bin/ninja

	local myqmakeargs=(
		$(usex bindist '' 'WEBENGINE_CONFIG+=use_proprietary_codecs')
		$(usex system-ffmpeg 'WEBENGINE_CONFIG+=use_system_ffmpeg' '')
		$(usex system-icu 'WEBENGINE_CONFIG+=use_system_icu' '')
	)
	qt5-build_src_configure
}
