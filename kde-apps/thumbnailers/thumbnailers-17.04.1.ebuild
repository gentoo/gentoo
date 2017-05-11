# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_BLOCK_SLOT4=false
KMNAME="kdegraphics-thumbnailers"
inherit kde5

DESCRIPTION="Thumbnail generators for PDF/PS and RAW files"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="raw"

DEPEND="
	$(add_frameworks_dep kio)
	$(add_qt_dep qtgui)
	raw? (
		$(add_kdeapps_dep libkdcraw)
		$(add_kdeapps_dep libkexiv2)
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package raw KF5KExiv2)
		$(cmake-utils_use_find_package raw KF5KDcraw)
	)

	kde5_src_configure
}
