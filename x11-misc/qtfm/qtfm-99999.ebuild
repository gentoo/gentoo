# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="Small, lightweight file manager based on pure Qt"
HOMEPAGE="https://qtfm.eu/"
EGIT_REPO_URI="https://github.com/rodlie/qtfm/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="+dbus ffmpeg imagemagick"

RDEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	sys-apps/file
	dbus? ( dev-qt/qtdbus:5 )
	ffmpeg? ( media-video/ffmpeg )
	imagemagick? ( >=media-gfx/imagemagick-7:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip
	dev-qt/linguist-tools:5
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_DBUS=$(usex dbus)
		-DENABLE_FFMPEG=$(usex ffmpeg)
		-DENABLE_MAGICK=$(usex imagemagick)
	)
	cmake_src_configure
}
