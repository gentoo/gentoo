# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=5.15.9
inherit ecm frameworks.kde.org

DESCRIPTION="QRCode and data matrix barcode library"
HOMEPAGE="https://invent.kde.org/frameworks/prison"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv"
IUSE="+dtmx qml +video +zxing"
REQUIRED_USE="video? ( zxing )"

RDEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	video? ( >=dev-qt/qtmultimedia-${QTMIN}:5 )
	media-gfx/qrencode:=
	dtmx? ( media-libs/libdmtx )
	zxing? ( media-libs/zxing-cpp:= )
	qml? ( >=dev-qt/qtdeclarative-${QTMIN}:5 )
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtwidgets-${QTMIN}:5 )
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package dtmx Dmtx)
		$(cmake_use_find_package qml Qt5Quick)
		$(cmake_use_find_package video Qt5Multimedia)
		$(cmake_use_find_package zxing ZXing)
	)

	ecm_src_configure
}
