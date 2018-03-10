# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="false"
inherit kde5

DESCRIPTION="Framework for detection and notification of device idle time"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="X xscreensaver"

REQUIRED_USE="xscreensaver? ( X )"

RDEPEND="
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libX11
		x11-libs/libxcb
		x11-libs/libXext
	)
	xscreensaver? (
		$(add_qt_dep qtdbus)
		x11-libs/libXScrnSaver
	)
"
DEPEND="${RDEPEND}"

src_prepare() {
	kde5_src_prepare
	if ! use xscreensaver; then
		sed -i -e "s/\${X11_Xscreensaver_FOUND}/0/" CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package X X11)
		$(cmake-utils_use_find_package X XCB)
	)

	kde5_src_configure
}
