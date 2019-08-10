# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="QRCode and data matrix barcode library"
HOMEPAGE="https://cgit.kde.org/prison.git"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="qml"

DEPEND="
	$(add_qt_dep qtgui)
	media-gfx/qrencode:=
	media-libs/libdmtx
	qml? ( $(add_qt_dep qtdeclarative) )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package qml Qt5Quick)
	)

	kde5_src_configure
}
