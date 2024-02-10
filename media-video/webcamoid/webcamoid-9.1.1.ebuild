# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Full featured webcam capture application"
HOMEPAGE="https://webcamoid.github.io"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/webcamoid/webcamoid.git"
	EGIT_BRANCH="master"
	inherit git-r3
	RESTRICT="mirror"
else
	SRC_URI="https://github.com/webcamoid/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="alsa ffmpeg gstreamer jack libuvc oss portaudio pulseaudio qtaudio qtcamera sdl v4lutils videoeffects debug headers v4l"

REQUIRED_USE="v4lutils? ( v4l )"

COMMON_DEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtquickcontrols2:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	ffmpeg?	( media-video/ffmpeg:= )
	gstreamer? ( >=media-libs/gstreamer-1.6.0 )
	jack? ( virtual/jack )
	libuvc? ( media-libs/libuvc )
	pulseaudio? ( media-libs/libpulse )
	qtaudio? ( dev-qt/qtmultimedia:5 )
	qtcamera? ( dev-qt/qtmultimedia:5 )
	sdl? ( media-libs/libsdl2 )
	v4l? ( media-libs/libv4l )
"
DEPEND="${COMMON_DEPEND}
	>=sys-kernel/linux-headers-3.6
"
RDEPEND="${COMMON_DEPEND}
	virtual/opengl
"

src_configure() {
	#Disable git in package source. If not disabled the cmake configure process will show
	#a lot of "fatal not a git repository" errors
	sed -i 's|find_program(GIT_BIN git)|#find_program(GIT_BIN git)|' libAvKys/cmake/ProjectCommons.cmake || die

	local mycmakeargs=(
		"-DNOMEDIAFOUNDATION=1"
		"-DNODSHOW=1"
		"-DNOWASAPI=1"
		"-DNOVLC=1"
		"-DNOPIPEWIRE=1"
		"-DNOPORTAUDIO=1" # PortAudio not packaged for gentoo
		"-DNOALSA=$(usex alsa 0 1)"
		"-DNOQTCAMERA=$(usex qtcamera 0 1)"
		"-DNOFFMPEG=$(usex ffmpeg 0 1)"
		"-DNOGSTREAMER=$(usex gstreamer 0 1)"
		"-DNOJACK=$(usex jack 0 1)"
		"-DNOLIBUVC=$(usex libuvc 0 1)"
		"-DNOPULSEAUDIO=$(usex pulseaudio 0 1)"
		"-DNOSDL=$(usex sdl 0 1)"
		"-DNOV4L2=$(usex v4l 0 1)"
		"-DNOV4LUTILS=$(usex v4lutils 0 1)"
		"-DNOVIDEOEFFECTS=$(usex videoeffects 0 1)"
	)
	cmake_src_configure
}

src_install() {
	docompress -x /usr/share/man/man1/${PN}.1.gz
	cmake_src_install
}
