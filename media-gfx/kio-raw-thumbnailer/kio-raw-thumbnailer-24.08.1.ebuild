# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="kdegraphics-thumbnailers"
PVCUT=$(ver_cut 1-3)
KFMIN=6.5.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="KIO thumbnail generator for RAW files"
HOMEPAGE="https://apps.kde.org/kdegraphics_thumbnailers/"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=kde-apps/libkdcraw-${PVCUT}:6
	>=kde-apps/libkexiv2-${PVCUT}:6
	>=kde-frameworks/kio-${KFMIN}:6
"
RDEPEND="${DEPEND}
	!<kde-apps/thumbnailers-24.05.2-r1:6
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
		-DCMAKE_DISABLE_FIND_PACKAGE_QMobipocket6=ON
	)

	ecm_src_configure
}
