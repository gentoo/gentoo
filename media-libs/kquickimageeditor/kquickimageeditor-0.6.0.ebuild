# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: ECMGenerateQDoc
ECM_TEST=true
KFMIN=6.13.0
QTMIN=6.8.1
inherit ecm kde.org

DESCRIPTION="QtQuick components providing basic image editing capabilities"
HOMEPAGE="https://invent.kde.org/libraries/kquickimageeditor
https://api.kde.org/kquickimageeditor/html/index.html"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="amd64 arm64 ~ppc64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="6"
IUSE="+opencv"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	opencv? ( media-libs/opencv:= )
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
	>=kde-frameworks/kirigami-${KFMIN}:6
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package opencv OpenCV)
	)
	ecm_src_configure
}
