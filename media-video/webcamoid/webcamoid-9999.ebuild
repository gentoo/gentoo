# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

DESCRIPTION="Full featured webcam capture application"
HOMEPAGE="https://webcamoid.github.io"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/webcamoid/webcamoid.git"
	inherit git-r3
else
	SRC_URI="https://github.com/webcamoid/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="alsa aom debug faac fdk-aac ffmpeg gstreamer headers jack lame libusb libuvc mp4
opus portaudio pulseaudio qtmedia rav1e screencast sdl svt-av1 v4l vlc vorbis vpx X x264"

COMMON_DEPEND="
	media-libs/libmikmod
	dev-qt/qtbase:6[concurrent,dbus,gui,network,opengl,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
	alsa? ( media-libs/alsa-lib )
	aom? ( media-libs/libaom:= )
	faac? ( media-libs/faac )
	fdk-aac? ( media-libs/fdk-aac:= )
	ffmpeg? ( media-video/ffmpeg:= )
	gstreamer? ( >=media-libs/gstreamer-1.6.0 )
	jack? ( virtual/jack )
	lame? ( media-sound/lame )
	libusb? ( dev-libs/libusb:1 )
	libuvc? ( >=media-libs/libuvc-0.0.7 )
	mp4? ( media-libs/libmp4v2 )
	opus? ( media-libs/opus )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-libs/libpulse )
	qtmedia? ( dev-qt/qtmultimedia:6 )
	rav1e? ( media-video/rav1e:= )
	screencast? ( media-video/pipewire:= )
	sdl? ( media-libs/libsdl2 )
	svt-av1? ( media-libs/svt-av1:= )
	v4l? ( media-libs/libv4l )
	vlc? ( media-video/vlc:= )
	vorbis? ( media-libs/libvorbis )
	vpx? ( media-libs/libvpx:= )
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXfixes
	)
	x264? ( media-libs/x264:= )
"
DEPEND="${COMMON_DEPEND}
	>=sys-kernel/linux-headers-3.6
"
RDEPEND="${COMMON_DEPEND}
	virtual/opengl
"

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
		-DNOAOMAV1=$(usex !aom)
		-DNOFAAC=$(usex !faac)
		-DNOFDKAAC=$(usex !fdk-aac)
		-DNOFFMPEG=$(usex !ffmpeg)
		-DNOGSTREAMER=$(usex !gstreamer)
		-DNOJACK=$(usex !jack)
		-DNOLAME=$(usex !lame)
		-DNOLIBUSB=$(usex !libusb)
		-DNOLIBUVC=$(usex !libuvc)
		-DNOLIBMP4V2=$(usex !mp4)
		-DNOLIBOPUS=$(usex !opus)
		-DNOPORTAUDIO=$(usex !portaudio)
		-DNOPULSEAUDIO=$(usex !pulseaudio)
		-DNOQTAUDIO=$(usex !qtmedia)
		-DNOQTCAMERA=$(usex !qtmedia)
		-DNOQTSCREENCAPTURE=$(usex !qtmedia)
		-DNORAVIE=$(usex !rav1e)
		-DNOPIPEWIRE=$(usex !screencast)
		-DNOSDL=$(usex !sdl)
		-DNOSVTAV1=$(usex !svt-av1)
		-DNOV4L2=$(usex !v4l)
		-DNOV4LUTILS=$(usex !v4l)
		-DNOVLC=$(usex !vlc)
		-DNOLIBVORBIS=$(usex !vorbis)
		-DNOLIBWEBM=$(usex !vpx)
		-DNOLIBVPX=$(usex !vpx)
		-DNOXLIBSCREENCAP=$(usex !X)
		-DNOX264=$(usex !x264)
	)
	cmake_src_configure
}

src_install() {
	docompress -x /usr/share/man/man1/${PN}.1.gz
	cmake_src_install
}
