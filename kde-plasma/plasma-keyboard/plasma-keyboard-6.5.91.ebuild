# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.22.0
QTMIN=6.10.1
inherit ecm plasma.kde.org xdg

DESCRIPTION="Virtual keyboard based on Qt Virtual Keyboard"

LICENSE="|| ( GPL-2 GPL-3 ) LGPL-2.1 LGPL-3"
SLOT="6"
KEYWORDS="~amd64"

# slot op: Uses Qt6::GuiPrivate for qxkbcommon_p.h
COMMON_DEPEND="
	dev-libs/wayland
	>=dev-qt/qtbase-${QTMIN}:6=[gui,wayland,X]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtvirtualkeyboard-${QTMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
"
RDEPEND="${COMMON_DEPEND}
	dev-libs/kirigami-addons
	>=kde-frameworks/kconfig-${KFMIN}:6[qml]
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/wayland-protocols-1.19
"
BDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[wayland]
	dev-util/wayland-scanner
	>=kde-frameworks/kcmutils-${KFMIN}:6
"
