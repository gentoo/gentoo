# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="kdegraphics-thumbnailers"
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="KIO thumbnail generator for DVI, EPS, PDF and PS files"
HOMEPAGE="https://apps.kde.org/kdegraphics_thumbnailers/"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=kde-frameworks/kio-${KFMIN}:6
"
RDEPEND="${DEPEND}
	!<kde-apps/thumbnailers-24.05.2-r1:6
	app-text/dvipsk
	app-text/ghostscript-gpl
"

src_prepare() {
	ecm_src_prepare
	ecm_punt_kf_module Archive
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_blend=OFF
		-DDISABLE_MOBIPOCKET=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_QMobipocket6=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_KExiv2Qt6=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_KDcrawQt6=ON
	)

	ecm_src_configure
}
