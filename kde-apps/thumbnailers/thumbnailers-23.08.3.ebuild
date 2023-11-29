# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="kdegraphics-thumbnailers"
PVCUT=$(ver_cut 1-3)
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Thumbnail generators for Mobipocket, PDF/PS and RAW files"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
IUSE="mobi raw"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	mobi? ( >=kde-apps/kdegraphics-mobipocket-${PVCUT}:5 )
	raw? (
		>=kde-apps/libkdcraw-${PVCUT}:5
		>=kde-apps/libkexiv2-${PVCUT}:5
	)
"
RDEPEND="${DEPEND}
	mobi? ( !<kde-apps/kdegraphics-mobipocket-21.12.50:5[thumbnail] )
"

src_configure() {
	local mycmakeargs=(
		-DDISABLE_MOBIPOCKET=$(usex !mobi)
		$(cmake_use_find_package raw KF5KExiv2)
		$(cmake_use_find_package raw KF5KDcraw)
	)

	ecm_src_configure
}
