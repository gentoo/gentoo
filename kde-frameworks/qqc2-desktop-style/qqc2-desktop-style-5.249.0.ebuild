# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
PVCUT=$(ver_cut 1-2)
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Style for QtQuickControls 2 that uses QWidget's QStyle for painting"

LICENSE="|| ( GPL-2+ LGPL-3+ )"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6=
	=kde-frameworks/kcolorscheme-${PVCUT}*:6
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/kiconthemes-${PVCUT}*:6
	=kde-frameworks/kirigami-${PVCUT}*:6
	=kde-frameworks/sonnet-${PVCUT}*:6[qml]
"
RDEPEND="${DEPEND}
	>=dev-qt/qt5compat-${QTMIN}:6
"
