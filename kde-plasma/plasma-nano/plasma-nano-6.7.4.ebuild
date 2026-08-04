# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.26.0
QTMIN=6.10.0
inherit ecm plasma.kde.org

DESCRIPTION="Minimal Plasma shell package"
HOMEPAGE="https://invent.kde.org/plasma/plasma-nano"

LICENSE="CC0-1.0 GPL-2+ LGPL-2+ MIT"
SLOT="6"
KEYWORDS="~amd64"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-plasma/kwayland-${KDE_CATV}:6
	>=kde-plasma/libplasma-${KDE_CATV}:6
"
RDEPEND="${DEPEND}"
