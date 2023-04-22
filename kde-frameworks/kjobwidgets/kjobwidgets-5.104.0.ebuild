# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=5.15.5
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing assorted widgets for showing the progress of jobs"

LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="X"

RDEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:5
	X? ( >=dev-qt/qtx11extras-${QTMIN}:5 )
"
DEPEND="${RDEPEND}
	X? (
		x11-base/xorg-proto
		x11-libs/libX11
	)
"
BDEPEND=">=dev-qt/linguist-tools-${QTMIN}:5"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package X X11)
	)

	ecm_src_configure
}
