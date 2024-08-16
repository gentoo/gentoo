# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="kdegraphics-thumbnailers"
PVCUT=$(ver_cut 1-3)
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="KIO thumbnail generator for RAW files"
HOMEPAGE="https://apps.kde.org/kdegraphics_thumbnailers/"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=kde-apps/libkdcraw-${PVCUT}:5
	>=kde-apps/libkexiv2-${PVCUT}:5
	>=kde-frameworks/kio-${KFMIN}:5
"
RDEPEND="${DEPEND}
	!<kde-apps/thumbnailers-23.08.5-r1:5
"

src_prepare() {
	ecm_src_prepare
	ecm_punt_kf_module Archive
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_blend=OFF
		-DBUILD_ps=OFF
		-DDISABLE_MOBIPOCKET=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_QMobipocket=ON
	)

	ecm_src_configure
}
