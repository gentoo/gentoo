# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils git-r3

DESCRIPTION="Most feature-rich GUI for net-libs/tox using Qt5"
HOMEPAGE="https://github.com/qTox/qTox"
SRC_URI=""
EGIT_REPO_URI="https://github.com/qTox/qTox.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="gtk X"

RDEPEND="
	dev-db/sqlcipher
	dev-libs/libsodium
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5[gif,jpeg,png,xcb]
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-gfx/qrencode
	media-libs/openal
	>=media-video/ffmpeg-2.6.3[webp,v4l]
	gtk? (	dev-libs/atk
			dev-libs/glib:2
			x11-libs/gdk-pixbuf[X]
			x11-libs/gtk+:2
			x11-libs/cairo[X]
			x11-libs/pango[X] )
	net-libs/tox:0/0.1[av]
	X? ( x11-libs/libX11
		x11-libs/libXScrnSaver )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_STATUSNOTIFIER=$(usex gtk)
		-DENABLE_GTK_SYSTRAY=$(usex gtk)
	)

	cmake-utils_src_configure
}
