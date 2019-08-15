# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KMNAME="kdegraphics-thumbnailers"
inherit kde5

DESCRIPTION="Thumbnail generators for PDF/PS and RAW files"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="raw"

DEPEND="
	$(add_frameworks_dep karchive)
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
