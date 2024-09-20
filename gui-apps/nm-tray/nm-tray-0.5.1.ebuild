# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A simple Qt-based NetworkManager front-end"
HOMEPAGE="https://github.com/palinek/nm-tray"
SRC_URI="https://github.com/palinek/nm-tray/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	dev-qt/qttools:6[linguist]
	>=dev-build/cmake-3.10
"
RDEPEND="
	dev-qt/qtbase:6[dbus,gui,network,widgets]
	kde-frameworks/networkmanager-qt:6
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DNM_TRAY_XDG_AUTOSTART_DIR=/etc/xdg/autostart
	)

	cmake_src_configure
}
