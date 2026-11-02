# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic toolchain-funcs xdg

DESCRIPTION="Full featured webcam capture application"
HOMEPAGE="https://webcamoid.github.io"
if [[ ${PV} == *9999* ]]; then
	EGIT_SUBMODULES=(
		-"libAvKys/ExtraPlugins" # git@github.com:webcamoid_WebcamoidPrivate.git
	)
	EGIT_REPO_URI="https://github.com/webcamoid/webcamoid.git"
	inherit git-r3
else
	SRC_URI="https://github.com/webcamoid/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="alsa debug ffmpeg headers libusb libuvc openmp portaudio
	pulseaudio qtmedia screencast v4l wayland X"

COMMON_DEPEND="
	media-libs/libmikmod
	dev-qt/qtbase:6[concurrent,dbus,gui,network,opengl,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( media-video/ffmpeg:= )
	libusb? ( dev-libs/libusb:1 )
	libuvc? ( >=media-libs/libuvc-0.0.7 )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-libs/libpulse )
	qtmedia? ( dev-qt/qtmultimedia:6 )
	screencast? ( media-video/pipewire:= )
	v4l? ( media-libs/libv4l )
	wayland? ( dev-libs/wayland )
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXfixes
	)
"
DEPEND="${COMMON_DEPEND}
	>=sys-kernel/linux-headers-3.6
"
RDEPEND="${COMMON_DEPEND}
	virtual/opengl
"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/927104
	# https://github.com/webcamoid/webcamoid/issues/702
	filter-lto

	#Disable git in package source. If not disabled the cmake configure process will show
	#a lot of "fatal not a git repository" errors
	sed -i 's|find_program(GIT_BIN git)|#find_program(GIT_BIN git)|' libAvKys/cmake/ProjectCommons.cmake || die

	local mycmakeargs=(
		-DNOVIDEOEFFECTS=0 # no extra deps, no IUSE
		-DNOCHECKUPDATES=1
		-DNOMEDIAFOUNDATION=1
		-DNODSHOW=1
		-DNOWASAPI=1
		-DNOALSA=$(usex !alsa)
		-DNOFFMPEG=$(usex !ffmpeg)
		-DNOLIBUSB=$(usex !libusb)
		-DNOLIBUVC=$(usex !libuvc)
		-DNOOPENMP=$(usex !openmp)
		-DNOPORTAUDIO=$(usex !portaudio)
		-DNOPULSEAUDIO=$(usex !pulseaudio)
		-DNOQTCAMERA=$(usex !qtmedia)
		-DNOQTSCREENCAPTURE=$(usex !qtmedia)
		-DNOPIPEWIRE=$(usex !screencast)
		-DNOV4L2=$(usex !v4l)
		-DNOV4LUTILS=$(usex !v4l)
		-DNOWLROOTS=$(usex !wayland)
		-DNOXLIBSCREENCAP=$(usex !X)
	)

	# Control QML debugging with the 'debug' USE flag #981081
	#
	# ```
	# $ webcamoid --help
	# QML debugging is enabled. Only use this in a safe environment.
	# ```
	# RelWithDebInfo enables QT_QML_DEBUG in StandAlone/src/CMakeLists.txt:
	# PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
	#
	# Set CMAKE_BUILD_TYPE to RelWithDebInfo when the 'debug' USE flag is
	# enabled, which activates QT_QML_DEBUG; otherwise, set it to Release
	# to keep QT_QML_DEBUG disabled.
	#
	# Alternatively, patch CMakeLists.txt to enable QT_QML_DEBUG only for
	# the Debug configuration:
	# PRIVATE $<$<CONFIG:Debug>:QT_QML_DEBUG>
	#
	# References:
	# - https://doc.qt.io/qt-6/qtquick-debugging.html#qml-debugging-infrastructure
	# - https://github.com/gentoo/gentoo/commit/e4a5df48b83e36dfe929eb6ef71abd064380e17c
	#
	# Needs to be here, otherwise gets overriden by cmake.eclass
	CMAKE_BUILD_TYPE=$(usex debug RelWithDebInfo Release) cmake_src_configure
}

src_install() {
	docompress -x /usr/share/man/man1/${PN}.1.gz
	cmake_src_install
}
