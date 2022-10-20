# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="A full featured webcam capture application"
HOMEPAGE="https://webcamoid.github.io"
SRC_URI="https://github.com/webcamoid/webcamoid/archive/refs/tags/${PV}.tar.gz"
RESTRICT="mirror"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
CMAKE_USE_DIR="${WORKDIR}/${PF}"
BUILD_DIR="${CMAKE_USE_DIR}/webcamoid-build"

IUSE="alsa -coreaudio ffmpeg gstreamer jack libuvc oss pulseaudio qtaudio v4lutils videoeffects debug headers v4l -pipewire vlc"

REQUIRED_USE="v4lutils? ( v4l )"

RDEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
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
	pipewire? ( media-video/pipewire )
"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-3.6
"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
	dev-util/cmake
"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		"-S ${WORKDIR}/${PF}"
		"-B ${WORKDIR}/${PF}/webcamoid-build"
		"-DNOMEDIAFOUNDATION=1"
		"-DNOAVFOUNDATION=1"
		"-DNODSHOW=1"
		"-DNOWASAPI=1"
		"-DNOALSA=$(usex alsa 0 1)"
		"-DNOCOREAUDIO=$(usex coreaudio 0 1)"
		"-DNOFFMPEG=$(usex ffmpeg 0 1)"
		"-DNOGSTREAMER=$(usex gstreamer 0 1)"
		"-DNOJACK=$(usex jack 0 1)"
		"-DNOLIBUVC=$(usex libuvc 0 1)"
		"-DNOPIPEWIRE=$(usex pipewire 0 1)"
		"-DNOPULSEAUDIO=$(usex pulseaudio 0 1)"
		"-DNOV4L2=$(usex v4l 0 1)"
		"-DNOV4LUTILS=$(usex v4lutils 0 1)"
		"-DNOVIDEOEFFECTS=$(usex videoeffects 0 1)"
		"-DNOVLC=$(usex vlc 0 1)"
	)
	cmake_src_configure
}

src_install() {
	dodoc "${S}/StandAlone/ManPages/src/webcamoid.1.in"
	cmake_src_install
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
