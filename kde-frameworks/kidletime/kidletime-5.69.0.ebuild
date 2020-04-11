# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="false"
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Framework for detection and notification of device idle time"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="X xscreensaver"

REQUIRED_USE="xscreensaver? ( X )"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libX11
		x11-libs/libxcb
		x11-libs/libXext
	)
	xscreensaver? (
		>=dev-qt/qtdbus-${QTMIN}:5
		x11-libs/libXScrnSaver
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	ecm_src_prepare
	if ! use xscreensaver; then
		sed -i -e "s/\${X11_Xscreensaver_FOUND}/0/" CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package X X11)
		$(cmake_use_find_package X XCB)
	)

	ecm_src_configure
}
