# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="true"
KFMIN=6.5.0
QTMIN=6.7.2
inherit ecm kde.org

DESCRIPTION="Full featured educational application for children from 2 to 10"
HOMEPAGE="https://gcompris.net/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="https://gcompris.net/download/qt/src/${PN}-qt-${PV}.tar.xz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-qt-${PV}"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="kiosk"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,network,widgets]
	>=dev-qt/qtcharts-${QTMIN}:6
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtmultimedia-${QTMIN}:6
	>=dev-qt/qtsensors-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
"
RDEPEND="${DEPEND}
	>=dev-qt/qtimageformats-${QTMIN}:6
	>=dev-qt/qtmultimedia-${QTMIN}:6[qml]
	>=dev-qt/qtsensors-${QTMIN}:6[qml]
"
BDEPEND="
	>=dev-qt/qttools-${QTMIN}:6[linguist]
	test? (
		dev-util/cppcheck
		llvm-core/clang
	)
"

src_configure() {
	local mycmakeargs=(
		-DCOMPILE_DOC=ON
		-DQML_BOX2D_MODULE=disabled
		-DWITH_KIOSK_MODE=$(usex kiosk)
	)
	ecm_src_configure
}
