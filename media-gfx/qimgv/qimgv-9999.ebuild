# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 cmake-utils

DESCRIPTION="A cross-platform image viewer with webm support. Written in qt5."
HOMEPAGE="https://github.com/easymodo/qimgv"

EGIT_REPO_URI="https://github.com/easymodo/qimgv.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	media-video/mpv[libmpv]
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
