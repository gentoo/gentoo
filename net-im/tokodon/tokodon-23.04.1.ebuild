# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=5.104.0
QTMIN=5.15.5
inherit ecm gear.kde.org

DESCRIPTION="Mastodon client for Plasma and Plasma Mobile"
HOMEPAGE="https://apps.kde.org/tokodon/"

LICENSE="CC-BY-SA-4.0 GPL-2+ GPL-3+ || ( LGPL-2.1+ LGPL-3+ ) MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

DEPEND="
	>=dev-libs/kirigami-addons-0.7.2:5
	dev-libs/qtkeychain:=[qt5(+)]
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtmultimedia-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwebsockets-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5[qml]
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/qqc2-desktop-style-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5[qml]
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-23.04.0-tokodon-not-neochat.patch" ) # git master

src_test() {
	local -x QT_QPA_PLATFORM=offscreen
	ecm_src_test
}
