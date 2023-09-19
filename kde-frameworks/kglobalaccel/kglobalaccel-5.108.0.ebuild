# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=5.15.9
inherit ecm frameworks.kde.org

DESCRIPTION="Framework to handle global shortcuts"

LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="X"

REQUIRED_USE="test? ( X )"
RESTRICT="test" # requires installed instance

RDEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	X? (
		=kde-frameworks/kconfig-${PVCUT}*:5
		=kde-frameworks/kcoreaddons-${PVCUT}*:5
		=kde-frameworks/kcrash-${PVCUT}*:5
		=kde-frameworks/kdbusaddons-${PVCUT}*:5
		=kde-frameworks/kwindowsystem-${PVCUT}*:5[X]
		x11-libs/libxcb
		x11-libs/xcb-util-keysyms
	)
"
DEPEND="${RDEPEND}
	test? (
		>=dev-qt/qtdeclarative-${QTMIN}:5
		>=dev-qt/qtquickcontrols2-${QTMIN}:5
		=kde-frameworks/kdeclarative-${PVCUT}*:5
	)
"
BDEPEND=">=dev-qt/linguist-tools-${QTMIN}:5"

src_configure() {
	local mycmakeargs=(
		-DBUILD_RUNTIME=$(usex X)
	)
	ecm_src_configure
}

src_test() {
	XDG_CURRENT_DESKTOP="KDE" ecm_src_test # bug 789342
}
