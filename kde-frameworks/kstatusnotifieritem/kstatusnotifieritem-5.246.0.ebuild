# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=6.6.0
inherit ecm frameworks.kde.org

DESCRIPTION="Implementation of Status Notifier Items"

LICENSE="LGPL-2+"
KEYWORDS="~amd64"
IUSE="X"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	=kde-frameworks/kwindowsystem-${PVCUT}*:6[X?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

src_configure() {
	local mycmakeargs=(
		-DWITHOUT_X11=$(usex !X)
	)

	ecm_src_configure
}
