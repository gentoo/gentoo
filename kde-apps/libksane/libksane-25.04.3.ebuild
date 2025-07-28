# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.13.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.7.2
inherit ecm gear.kde.org xdg

DESCRIPTION="SANE Library interface based on KDE Frameworks"

LICENSE="|| ( LGPL-2.1 LGPL-3 )"
SLOT="6"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="kwallet"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=media-libs/ksanecore-${PVCUT}:6
	kwallet? ( >=kde-frameworks/kwallet-${KFMIN}:6 )
"
RDEPEND="${DEPEND}
	>=kde-apps/libksane-common-${PV}
"

# Shipped by kde-apps/libksane-common package for shared use w/ SLOT 5
ECM_REMOVE_FROM_INSTALL=(
	/usr/share/icons/hicolor/16x16/actions
)

src_prepare() {
	ecm_src_prepare
	ecm_punt_po_install
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package kwallet KF6Wallet)
	)
	ecm_src_configure
}
