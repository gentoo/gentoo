# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 xdg-utils cmake

DESCRIPTION="A small, lightweight file manager for desktops based on pure Qt"
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
	ffmpeg? ( virtual/ffmpeg )
	imagemagick? ( >=media-gfx/imagemagick-7:= )
"
DEPEND="
	${RDEPEND}
	app-arch/unzip
	dev-qt/linguist-tools:5
"
PATCHES=(
	"${FILESDIR}"/${PN}-99999-cmake.patch
)

src_configure() {
	mycmakeargs=(
		-DENABLE_DBUS="$(usex dbus)"
		-DENABLE_FFMPEG="$(usex ffmpeg)"
		-DENABLE_MAGICK="$(usex imagemagick)"
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
