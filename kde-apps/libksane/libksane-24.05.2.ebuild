# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.3.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="SANE Library interface based on KDE Frameworks"

LICENSE="|| ( LGPL-2.1 LGPL-3 )"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~riscv"
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
	!${CATEGORY}/${PN}:5[-kf6compat(-)]
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package kwallet KF6Wallet)
	)
	ecm_src_configure
}
