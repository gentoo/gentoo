# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
PVCUT=$(ver_cut 1-2)
inherit ecm kde.org

DESCRIPTION="Framework to handle super user actions"
LICENSE="LGPL-2"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="X"

RDEPEND="
	>=kde-frameworks/kconfig-${PVCUT}:5
	>=kde-frameworks/kcoreaddons-${PVCUT}:5
	>=kde-frameworks/ki18n-${PVCUT}:5
	>=kde-frameworks/kpty-${PVCUT}:5
	>=kde-frameworks/kservice-${PVCUT}:5
	X? ( x11-libs/libX11 )
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package X X11)
	)

	ecm_src_configure
}
