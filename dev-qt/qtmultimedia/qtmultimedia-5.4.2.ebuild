# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtmultimedia/qtmultimedia-5.4.2.ebuild,v 1.1 2015/06/17 15:21:33 pesa Exp $

EAPI=5
inherit qt5-build

DESCRIPTION="The Multimedia module for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~hppa ~ppc64 ~x86"
fi

IUSE="alsa +gstreamer openal +opengl pulseaudio qml widgets"

RDEPEND="
	>=dev-qt/qtcore-${PV}:5
	>=dev-qt/qtgui-${PV}:5
	>=dev-qt/qtnetwork-${PV}:5
	alsa? ( media-libs/alsa-lib )
	gstreamer? (
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-bad:0.10
		media-libs/gst-plugins-base:0.10
	)
	pulseaudio? ( media-sound/pulseaudio )
	qml? (
		>=dev-qt/qtdeclarative-${PV}:5
		openal? ( media-libs/openal )
	)
	widgets? (
		>=dev-qt/qtwidgets-${PV}:5
		opengl? ( >=dev-qt/qtopengl-${PV}:5 )
	)
"
DEPEND="${RDEPEND}
	x11-proto/videoproto
"

src_prepare() {
	qt_use_compile_test alsa
	qt_use_compile_test gstreamer
	qt_use_compile_test openal
	qt_use_compile_test pulseaudio

	qt_use_disable_mod opengl opengl \
		src/multimediawidgets/multimediawidgets.pro

	qt_use_disable_mod qml quick \
		src/src.pro

	qt_use_disable_mod widgets widgets \
		src/src.pro \
		src/gsttools/gsttools.pro \
		src/plugins/gstreamer/common.pri

	qt5-build_src_prepare
}
