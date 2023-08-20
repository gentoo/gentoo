# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Multimedia (audio, video, radio, camera) library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

IUSE="alsa +ffmpeg gstreamer pulseaudio v4l vaapi"
REQUIRED_USE="
	|| ( ffmpeg gstreamer )
	vaapi? ( ffmpeg )
"

RDEPEND="
	=dev-qt/qtbase-${PV}*:6[gui,network,widgets]
	=dev-qt/qtdeclarative-${PV}*:6
	=dev-qt/qtquick3d-${PV}*:6
	=dev-qt/qtshadertools-${PV}*:6
	=dev-qt/qtsvg-${PV}*:6
	alsa? ( media-libs/alsa-lib )
	ffmpeg? (
		media-libs/libva:=
		media-video/ffmpeg:=
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXrandr
	)
	gstreamer? (
		dev-libs/glib:2
		media-libs/gst-plugins-bad:1.0
		media-libs/gst-plugins-base:1.0
		media-libs/gstreamer:1.0
		media-libs/libglvnd
	)
	pulseaudio? ( media-libs/libpulse[glib] )
	vaapi? (
		=dev-qt/qtbase-${PV}*:6[opengl]
		media-libs/libglvnd
		media-libs/libva:=
	)
"
DEPEND="
	${RDEPEND}
	gstreamer? ( x11-base/xorg-proto )
	v4l? ( sys-kernel/linux-headers )
"

src_configure() {
	local mycmakeargs=(
		$(qt_feature alsa)
		$(qt_feature ffmpeg)
		$(qt_feature gstreamer)
		$(qt_feature pulseaudio)
		$(qt_feature v4l linux_v4l)
		$(qt_feature vaapi)
	)

	qt6-build_src_configure
}
