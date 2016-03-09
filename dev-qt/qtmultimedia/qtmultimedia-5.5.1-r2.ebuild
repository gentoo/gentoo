# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit qt5-build

DESCRIPTION="The Multimedia module for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~hppa ppc64 ~x86"
fi

IUSE="alsa gles2 gstreamer gstreamer010 openal pulseaudio qml widgets"
REQUIRED_USE="?? ( gstreamer gstreamer010 )"

RDEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}
	~dev-qt/qtnetwork-${PV}
	alsa? ( media-libs/alsa-lib )
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-bad:1.0
		media-libs/gst-plugins-base:1.0
	)
	gstreamer010? (
		dev-libs/glib:2
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-bad:0.10
		media-libs/gst-plugins-base:0.10
	)
	pulseaudio? ( media-sound/pulseaudio )
	qml? (
		~dev-qt/qtdeclarative-${PV}
		gles2? ( ~dev-qt/qtgui-${PV}[egl,gles2] )
		!gles2? ( ~dev-qt/qtgui-${PV}[-egl] )
		openal? ( media-libs/openal )
	)
	widgets? (
		~dev-qt/qtopengl-${PV}
		~dev-qt/qtwidgets-${PV}
	)
"
DEPEND="${RDEPEND}
	gstreamer? ( x11-proto/videoproto )
"

PATCHES=(
	# bug 572426
	"${FILESDIR}/${P}-Relax-ALSA-version-checks-for-1.1.x.patch"
)

src_prepare() {
	# do not rely on qtbase configuration
	sed -i -e 's/contains(QT_CONFIG, \(alsa\|pulseaudio\))://' \
		qtmultimedia.pro || die

	qt_use_compile_test alsa
	qt_use_compile_test gstreamer
	qt_use_compile_test openal
	qt_use_compile_test pulseaudio

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
		$(usex gstreamer 'GST_VERSION=1.0' '')
		$(usex gstreamer010 'GST_VERSION=0.10' '')
	)
	qt5-build_src_configure
}
