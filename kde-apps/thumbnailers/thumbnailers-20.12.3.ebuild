# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_ORG_NAME="kdegraphics-thumbnailers"
PVCUT=$(ver_cut 1-3)
KFMIN=5.75.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Thumbnail generators for PDF/PS and RAW files"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 x86"
IUSE="raw"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	raw? (
		>=kde-apps/libkdcraw-${PVCUT}:5
		>=kde-apps/libkexiv2-${PVCUT}:5
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package raw KF5KExiv2)
		$(cmake_use_find_package raw KF5KDcraw)
	)

	ecm_src_configure
}
