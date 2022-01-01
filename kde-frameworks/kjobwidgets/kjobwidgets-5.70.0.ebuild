# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Framework providing assorted widgets for showing the progress of jobs"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE="nls X"

BDEPEND="
	nls? ( >=dev-qt/linguist-tools-${QTMIN}:5 )
"
RDEPEND="
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	X? ( >=dev-qt/qtx11extras-${QTMIN}:5 )
"
DEPEND="${RDEPEND}
	X? (
		x11-base/xorg-proto
		x11-libs/libX11
	)
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package X X11)
	)

	ecm_src_configure
}
