# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="An easy to use screencast creator to record educational videos,
live recordings of browser, installation, videoconferences"
HOMEPAGE="http://linuxecke.volkoh.de/vokoscreen/vokoscreen.html"

if [[ ${PV} = *9999*  ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vkohaupt/vokoscreen.git"
	SRC_URI=""
	KEYWORDS=""
	MY_PV=""
else
	MY_PV="2.5.8-beta"
	SRC_URI="https://github.com/vkohaupt/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND=">=dev-qt/qtcore-5.7
		media-libs/gst-plugins-bad
		media-sound/alsa-utils
		x11-libs/libX11
		media-sound/lame
		media-libs/libv4l
		x11-misc/xdg-utils
		sys-process/lsof
		>=media-video/ffmpeg-1.1.0
		media-sound/pulseaudio"

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
