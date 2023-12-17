# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.6.0
inherit ecm frameworks.kde.org

DESCRIPTION="QRCode and data matrix barcode library"
HOMEPAGE="https://invent.kde.org/frameworks/prison"

LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE="qml"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=dev-qt/qtmultimedia-${QTMIN}:6
	media-gfx/qrencode:=
	media-libs/libdmtx
	media-libs/zxing-cpp:=
	qml? ( >=dev-qt/qtdeclarative-${QTMIN}:6 )
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtbase-${QTMIN}:6[widgets] )
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Quick)
	)

	ecm_src_configure
}
