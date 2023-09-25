# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
ECM_TEST="false"
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.9
inherit ecm frameworks.kde.org

DESCRIPTION="Helper library to speed up start of applications on KDE workspaces"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="+caps +man X"

RDEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/kcrash-${PVCUT}*:5
	=kde-frameworks/kdbusaddons-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
	=kde-frameworks/kio-${PVCUT}*:5
	=kde-frameworks/kservice-${PVCUT}*:5
	=kde-frameworks/kwindowsystem-${PVCUT}*:5[X?]
	caps? ( sys-libs/libcap )
	X? (
		x11-libs/libX11
		x11-libs/libxcb
	)
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"
BDEPEND="man? ( >=kde-frameworks/kdoctools-${PVCUT}:5 )"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package caps Libcap)
		$(cmake_use_find_package man KF5DocTools)
		-DWITH_X11=$(usex X)
	)

	ecm_src_configure
}
