# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic qt6-build

DESCRIPTION="Multimedia (audio, video, radio, camera) library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

IUSE="
	+X alsa eglfs +ffmpeg gstreamer opengl pulseaudio
	qml v4l vaapi vulkan wayland
"
# tst_qmediaplayerbackend hard requires qml, review in case becomes optional
REQUIRED_USE="
	|| ( ffmpeg gstreamer )
	eglfs? ( ffmpeg opengl qml )
	test? ( qml )
	vaapi? ( ffmpeg opengl )
"

# gstreamer[X=] is to avoid broken gst detect if -X w/ gst[X] w/o xorg-proto
# (*could* be removed if gst-plugins-base[X] RDEPENDs on xorg-proto)
RDEPEND="
	~dev-qt/qtbase-${PV}:6[gui,network,opengl=,vulkan=,widgets]
	alsa? (
		!pulseaudio? ( media-libs/alsa-lib )
	)
	ffmpeg? (
		~dev-qt/qtbase-${PV}:6[X=,concurrent,eglfs=]
		media-video/ffmpeg:=[vaapi?]
		X? (
			x11-libs/libX11
			x11-libs/libXext
			x11-libs/libXrandr
		)
	)
	gstreamer? (
		dev-libs/glib:2
		media-libs/gst-plugins-bad:1.0
		media-libs/gst-plugins-base:1.0[X=]
		media-libs/gstreamer:1.0
		opengl? (
			~dev-qt/qtbase-${PV}:6[X?,wayland?]
			media-libs/gst-plugins-base:1.0[X?,egl,opengl,wayland?]
		)
	)
	opengl? ( media-libs/libglvnd )
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
	vulkan? ( dev-util/vulkan-headers )
"
BDEPEND="~dev-qt/qtshadertools-${PV}:6"

CMAKE_SKIP_TESTS=(
	# unimportant and expects all backends to be available (bug #928420)
	tst_backends
	# tries to use real alsa or pulseaudio and fails in sandbox
	tst_qaudiosink
	tst_qaudiosource
	tst_qmediacapture_gstreamer
	tst_qmediacapturesession
	tst_qmediaplayerbackend
	tst_qsoundeffect
	# may try to use v4l2 or hardware acceleration depending on availability
	tst_qscreencapture_integration
	tst_qscreencapturebackend
	tst_qvideoframebackend
	# fails with offscreen rendering
	tst_qvideoframecolormanagement
	tst_qwindowcapturebackend
)

src_configure() {
	# normally passed by the build system, but needed for 32-on-64 chroots
	use x86 && append-cppflags -DPFFFT_SIMD_DISABLE

	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Qml)
		$(qt_feature ffmpeg)
		$(qt_feature gstreamer)
		$(usev gstreamer "
			$(qt_feature opengl gstreamer_gl)
			$(usev opengl "
				$(qt_feature X gstreamer_gl_x11)
				$(qt_feature wayland gstreamer_gl_wayland)
			")
		")
		$(qt_feature pulseaudio)
		$(qt_feature v4l linux_v4l)
		$(qt_feature vaapi)
	)

	# ALSA backend is experimental off-by-default and can take priority
	# causing problems (bug #935146), disable if USE=pulseaudio is set
	# (also do not want unnecessary usage of ALSA plugins -> pulse)
	if use alsa && use pulseaudio; then
		# einfo should be enough given pure-ALSA users tend to disable pulse
		einfo "Warning: USE=alsa is ignored when USE=pulseaudio is set"
		mycmakeargs+=( -DQT_FEATURE_alsa=OFF )
	else
		mycmakeargs+=( $(qt_feature alsa) )
	fi

	qt6-build_src_configure
}

src_install() {
	qt6-build_src_install

	if use test; then
		local delete=( # sigh
			"${D}${QT6_LIBDIR}"/cmake/Qt6Multimedia/Qt6MockMultimediaPlugin*.cmake
			"${D}${QT6_MKSPECSDIR}"/modules/qt_plugin_mockmultimediaplugin.pri
			"${D}${QT6_PLUGINDIR}"/multimedia/libmockmultimediaplugin.*
			"${D}${QT6_PLUGINDIR}"/multimedia/objects-*
		)
		# using -f given not tracking which tests may be skipped or not
		rm -rf -- "${delete[@]}" || die
	fi
}
