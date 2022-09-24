# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Qt Multimedia"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

IUSE="gstreamer"

RDEPEND="
	=dev-qt/qtbase-${PV}*[gui,network,widgets]
	=dev-qt/qtdeclarative-${PV}*
	=dev-qt/qtshadertools-${PV}*
	=dev-qt/qtsvg-${PV}*
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-bad:1.0
		media-libs/gst-plugins-base:1.0
		media-libs/libglvnd
	)
"
DEPEND="${RDEPEND}
	gstreamer? ( x11-base/xorg-proto )
"

src_configure() {
	# TODO: linux_v4l automagic
	local mycmakeargs=(
		-DQT_FEATURE_alsa=off
		-DQT_FEATURE_pulseaudio=off
		$(qt_feature gstreamer)
	)

	qt6-build_src_configure
}
