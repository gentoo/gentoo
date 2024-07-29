# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="true"
QTMIN=5.15.5
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
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtmultimedia-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtsensors-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
"
RDEPEND="${DEPEND}
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=dev-qt/qtmultimedia-${QTMIN}:5[gstreamer,qml]
	>=dev-qt/qtquickcontrols-${QTMIN}:5
"
BDEPEND="
	>=dev-qt/linguist-tools-${QTMIN}:5
	test? (
		dev-util/cppcheck
		sys-devel/clang
	)
"

src_configure() {
	local mycmakeargs=(
		-DQML_BOX2D_MODULE=disabled
		-DWITH_KIOSK_MODE=$(usex kiosk)
	)
	ecm_src_configure
}
