# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils unpacker xdg-utils

DESCRIPTION="Most feature-rich GUI for net-libs/tox using Qt5"
HOMEPAGE="https://github.com/qTox/qTox"
SRC_URI="https://github.com/qTox/qTox/releases/download/v${PV}/v${PV}.tar.lz -> ${P}.tar.lz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk test X"

S="${WORKDIR}"

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
	$(unpacker_src_uri_depends)
	dev-qt/linguist-tools:5
	virtual/pkgconfig
	test? ( dev-qt/qttest:5 )
"

src_prepare() {
	cmake-utils_src_prepare

	# bug 628574
	if ! use test; then
		sed -i CMakeLists.txt -e "/include(Testing)/s/^/#/" || die
		sed -i cmake/Dependencies.cmake -e "/find_package(Qt5Test/s/^/#/" || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_STATUSNOTIFIER=$(usex gtk)
		-DENABLE_GTK_SYSTRAY=$(usex gtk)
		-DGIT_DESCRIBE="${PV}"
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
