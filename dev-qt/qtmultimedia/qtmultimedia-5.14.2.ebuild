# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qt5-build

DESCRIPTION="Multimedia (audio, video, radio, camera) library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm ~arm64 ~hppa ~ppc ppc64 ~sparc x86"
fi

IUSE="alsa gles2-only gstreamer openal pulseaudio qml widgets"

RDEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}[gles2-only=]
	~dev-qt/qtnetwork-${PV}
	alsa? ( media-libs/alsa-lib )
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-bad:1.0
		media-libs/gst-plugins-base:1.0
	)
	pulseaudio? ( media-sound/pulseaudio[glib] )
	qml? (
		~dev-qt/qtdeclarative-${PV}
		gles2-only? ( ~dev-qt/qtgui-${PV}[egl] )
		openal? ( media-libs/openal )
	)
	widgets? (
		~dev-qt/qtopengl-${PV}
		~dev-qt/qtwidgets-${PV}[gles2-only=]
	)
"
DEPEND="${RDEPEND}
	gstreamer? ( x11-base/xorg-proto )
"

src_prepare() {
	sed -i -e '/CONFIG\s*+=/ s/optimize_full//' \
		src/multimedia/multimedia.pro || die

	qt_use_disable_config openal openal \
		src/imports/imports.pro

	qt_use_disable_mod qml quick \
		src/src.pro \
		src/plugins/plugins.pro

	qt_use_disable_mod widgets widgets \
		src/src.pro \
		src/gsttools/gsttools.pro \
		src/plugins/gstreamer/common.pri

	qt5-build_src_prepare
}

src_configure() {
	local myqmakeargs=(
		--
		$(qt_use alsa)
		$(qt_use gstreamer)
		$(qt_use pulseaudio)
	)
	qt5-build_src_configure
}
