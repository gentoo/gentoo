# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="kdegraphics-thumbnailers"
PVCUT=$(ver_cut 1-3)
KFMIN=6.0.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Thumbnail generators for Mobipocket, PDF/PS and RAW files"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64"
IUSE="mobi raw"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	mobi? ( >=kde-apps/kdegraphics-mobipocket-${PVCUT}:6 )
	raw? (
		>=kde-apps/libkdcraw-${PVCUT}:6
		>=kde-apps/libkexiv2-${PVCUT}:6
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DDISABLE_MOBIPOCKET=$(usex !mobi)
		$(cmake_use_find_package raw KExiv2Qt6)
		$(cmake_use_find_package raw KDcrawQt6)
	)

	ecm_src_configure
}
