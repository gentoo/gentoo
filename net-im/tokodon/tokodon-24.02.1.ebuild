# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=6.0.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Mastodon client for Plasma and Plasma Mobile"
HOMEPAGE="https://apps.kde.org/tokodon/"

LICENSE="CC-BY-SA-4.0 GPL-2+ GPL-3+ || ( LGPL-2.1+ LGPL-3+ ) MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/kirigami-addons:6
	>=dev-libs/qtkeychain-0.14.1-r1:=[qt6]
	>=dev-qt/qtbase-${QTMIN}:6[gui,network,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-qt/qtwebsockets-${QTMIN}:6
	>=dev-qt/qtwebview-${QTMIN}:6
	>=kde-frameworks/breeze-icons-${KFMIN}:*
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/purpose-${KFMIN}:6
	>=kde-frameworks/qqc2-desktop-style-${KFMIN}:6
	media-libs/mpvqt
"
RDEPEND="${DEPEND}
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/sonnet-${KFMIN}:6[qml]
"
BDEPEND="virtual/pkgconfig"
