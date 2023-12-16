# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="true"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Client for Matrix, the decentralized communication protocol"
HOMEPAGE="https://apps.kde.org/neochat/"

LICENSE="GPL-3+ handbook? ( CC-BY-SA-4.0 )"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 x86"

DEPEND="
	app-text/cmark:=
	>=dev-libs/kirigami-addons-0.7.2:5
	dev-libs/qcoro5
	dev-libs/qtkeychain:=[qt5(+)]
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtmultimedia-${QTMIN}:5[gstreamer]
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5[qml]
	>=kde-frameworks/knotifications-${KFMIN}:5[qml]
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/qqc2-desktop-style-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5[qml]
	media-libs/kquickimageeditor:5
	>=net-libs/libquotient-0.8:=[qt5(+)]
"
RDEPEND="${DEPEND}
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=dev-qt/qtlocation-${QTMIN}:5
	>=dev-qt/qtmultimedia-${QTMIN}:5[qml]
	>=dev-qt/qtpositioning-${QTMIN}:5[qml]
	>=kde-frameworks/kquickcharts-${KFMIN}:5
	>=kde-frameworks/purpose-${KFMIN}:5
"
BDEPEND="virtual/pkgconfig"
