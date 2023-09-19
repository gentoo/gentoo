# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic qt6-build

DESCRIPTION="Multimedia (audio, video, radio, camera) library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

IUSE="+X alsa +ffmpeg gstreamer opengl pulseaudio qml v4l vaapi vulkan"
# tst_qmediaplayerbackend hard requires qml, review in case becomes optional
REQUIRED_USE="
	|| ( ffmpeg gstreamer )
	vaapi? ( ffmpeg )
	test? ( qml )
"

RDEPEND="
	~dev-qt/qtbase-${PV}:6[gui,network,opengl=,vulkan=,widgets]
	alsa? ( media-libs/alsa-lib )
	ffmpeg? (
		~dev-qt/qtbase-${PV}:6[X=]
		media-video/ffmpeg:=[vaapi?]
		X? (
			x11-libs/libX11
			x11-libs/libXext
			x11-libs/libXrandr
		)
		vaapi? ( media-libs/libglvnd )
	)
	gstreamer? (
		dev-libs/glib:2
		media-libs/gst-plugins-bad:1.0
		media-libs/gst-plugins-base:1.0[X=,opengl?]
		media-libs/gstreamer:1.0
		opengl? ( media-libs/libglvnd )
	)
	pulseaudio? ( media-libs/libpulse )
	qml? (
		~dev-qt/qtdeclarative-${PV}:6
		~dev-qt/qtquick3d-${PV}:6
	)
"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )
	v4l? ( sys-kernel/linux-headers )
"
BDEPEND="~dev-qt/qtshadertools-${PV}:6"

CMAKE_SKIP_TESTS=(
	# tries to use real alsa or pulseaudio and fails in sandbox
	tst_qaudiosink
	tst_qaudiosource
	tst_qmediacapturesession
	tst_qmediaplayerbackend
	tst_qsoundeffect
	# may try to use hardware acceleration for encoding
	tst_qscreencapture_integration
)

src_configure() {
	# normally passed by the build system, but needed for 32-on-64 chroots
	use x86 && append-cppflags -DPFFFT_SIMD_DISABLE

	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Qml)
		$(qt_feature alsa)
		$(qt_feature ffmpeg)
		$(qt_feature gstreamer)
		$(usev gstreamer $(qt_feature opengl gstreamer_gl))
		$(qt_feature pulseaudio)
		$(qt_feature v4l linux_v4l)
		$(qt_feature vaapi)
	)

	qt6-build_src_configure
}
