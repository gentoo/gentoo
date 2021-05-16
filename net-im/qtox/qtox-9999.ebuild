# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3 xdg

DESCRIPTION="Most feature-rich GUI for net-libs/tox using Qt5"
HOMEPAGE="https://github.com/qTox/qTox"
EGIT_REPO_URI="https://github.com/qTox/qTox.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="notification test X"

RESTRICT="!test? ( test )"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
RDEPEND="
	dev-db/sqlcipher
	dev-libs/libsodium:=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	|| (
		dev-qt/qtgui:5[gif,jpeg,png,X(-)]
		dev-qt/qtgui:5[gif,jpeg,png,xcb(-)]
	)
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-gfx/qrencode:=
	media-libs/libexif:=
	media-libs/openal
	>=media-video/ffmpeg-2.6.3:=[webp,v4l]
	net-libs/tox:0/0.2[av]
	notification? ( x11-libs/gtk+:2 )
	X? ( x11-libs/libX11
		x11-libs/libXScrnSaver )
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

src_prepare() {
	cmake_src_prepare

	# bug 628574
	if ! use test; then
		sed -i CMakeLists.txt -e "/include(Testing)/d" || die
		sed -i cmake/Dependencies.cmake -e "/find_package(Qt5Test/d" || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_STATUSNOTIFIER=$(usex notification)
		-DENABLE_GTK_SYSTRAY=$(usex notification)
		-DPLATFORM_EXTENSIONS=$(usex X)
		-DUSE_FILTERAUDIO=OFF
	)

	cmake_src_configure
}
