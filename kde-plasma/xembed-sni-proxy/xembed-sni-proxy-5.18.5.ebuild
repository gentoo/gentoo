# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_ORG_NAME="plasma-workspace"
KFMIN=5.66.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.12.3
inherit cmake kde.org

DESCRIPTION="Legacy xembed tray icons support for SNI-only system trays"
HOMEPAGE="https://cgit.kde.org/plasma-workspace.git/tree/xembed-sni-proxy/Readme.md"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="
	>=dev-qt/qtcore-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=kde-frameworks/extra-cmake-modules-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	x11-libs/libxcb
	x11-libs/libXtst
	x11-libs/xcb-util-image
"
RDEPEND="${DEPEND}
	!<kde-plasma/plasma-workspace-5.14.2:5
	!kde-plasma/xembed-sni-proxy:0
"

S="${S}/${PN}"

PATCHES=( "${FILESDIR}/${PN}-5.14.90-standalone.patch" )

src_prepare() {
	cmake_src_prepare

	sed -e "/set/s/GENTOO_PV/$(ver_cut 1-3)/" \
		-i CMakeLists.txt || die "Failed to prepare CMakeLists.txt"
}
