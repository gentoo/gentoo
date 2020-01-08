# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="QRCode and data matrix barcode library"
HOMEPAGE="https://cgit.kde.org/prison.git"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="qml"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	media-gfx/qrencode:=
	media-libs/libdmtx
	qml? ( >=dev-qt/qtdeclarative-${QTMIN}:5 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt5Quick)
	)

	ecm_src_configure
}
