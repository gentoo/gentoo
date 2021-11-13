# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="QRCode and data matrix barcode library"
HOMEPAGE="https://invent.kde.org/frameworks/prison"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="qml"

RDEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	media-gfx/qrencode:=
	media-libs/libdmtx
	media-libs/zxing-cpp
	qml? ( >=dev-qt/qtdeclarative-${QTMIN}:5 )
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtwidgets-${QTMIN}:5 )
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt5Quick)
	)

	ecm_src_configure
}
