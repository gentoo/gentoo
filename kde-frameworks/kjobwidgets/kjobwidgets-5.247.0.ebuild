# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=6.6.0
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing assorted widgets for showing the progress of jobs"

LICENSE="LGPL-2+"
KEYWORDS="~amd64"
IUSE="X"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/knotifications-${PVCUT}*:6
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:6
"
DEPEND="${RDEPEND}
	X? (
		x11-base/xorg-proto
		x11-libs/libX11
	)
"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package X X11)
	)

	ecm_src_configure
}
