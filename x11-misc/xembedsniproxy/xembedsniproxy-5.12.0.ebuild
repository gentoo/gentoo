# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A program to use legacy Xembed tray icons with SNI-only trays"
HOMEPAGE="https://cgit.kde.org/plasma-workspace.git/tree/xembed-sni-proxy/Readme.md"
SRC_URI="mirror://kde/stable/plasma/${PV}/plasma-workspace-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdbus:5
	dev-qt/qtx11extras:5
	kde-frameworks/kwindowsystem:5
	x11-libs/libxcb
	x11-libs/libXtst
	x11-libs/xcb-util-image
"
DEPEND="
	kde-frameworks/extra-cmake-modules:5
	${CDEPEND}
"
RDEPEND="
	!kde-plasma/plasma-workspace:5
	${CDEPEND}
"

S="${WORKDIR}/plasma-workspace-${PV}/xembed-sni-proxy"
PATCHES=( "${FILESDIR}/${PN}-5.10.3-Standalone-build.patch" )
