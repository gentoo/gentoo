# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="A full featured webcam capture application"
HOMEPAGE="https://webcamoid.github.io"
SRC_URI="https://github.com/webcamoid/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

IUSE="alsa coreaudio ffmpeg gstreamer jack libuvc oss pulseaudio qtaudio v4lutils videoeffects debug headers v4l"

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
	pulseaudio? ( media-sound/pulseaudio )
	qtaudio? ( dev-qt/qtmultimedia:5 )
	v4l? ( media-libs/libv4l )
"
DEPEND="${COMMON_DEPEND}
	>=sys-kernel/linux-headers-3.6
"
RDEPEND="${COMMON_DEPEND}
	virtual/opengl
"

src_configure() {
	#Disable git in package source. If not disabled the cmake configure process will show a lot of "fatal not a git repository" errors
	sed -i 's|find_program(GIT_BIN git)|#find_program(GIT_BIN git)|' libAvKys/cmake/ProjectCommons.cmake || die

	local mycmakeargs=(
		"-DNOMEDIAFOUNDATION=1"
		"-DNOAVFOUNDATION=1"
		"-DNODSHOW=1"
		"-DNOWASAPI=1"
		"-DNOVLC=1"
		"-DNOPIPEWIRE=1"
		"-DNOALSA=$(usex alsa 0 1)"
		"-DNOCOREAUDIO=$(usex coreaudio 0 1)"
		"-DNOFFMPEG=$(usex ffmpeg 0 1)"
		"-DNOGSTREAMER=$(usex gstreamer 0 1)"
		"-DNOJACK=$(usex jack 0 1)"
		"-DNOLIBUVC=$(usex libuvc 0 1)"
		"-DNOPULSEAUDIO=$(usex pulseaudio 0 1)"
		"-DNOV4L2=$(usex v4l 0 1)"
		"-DNOV4LUTILS=$(usex v4lutils 0 1)"
		"-DNOVIDEOEFFECTS=$(usex videoeffects 0 1)"
	)
	cmake_src_configure
}

src_install() {
	docompress -x /usr/share/man/${PN}.1.gz
	cmake_src_install
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
