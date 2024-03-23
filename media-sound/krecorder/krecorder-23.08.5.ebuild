# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="utilities"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Convergent audio recording application for Plasma"
HOMEPAGE="https://apps.kde.org/krecorder/"

LICENSE="CC0-1.0 CC-BY-4.0 GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"

DEPEND="
	>=dev-libs/kirigami-addons-0.6:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtmultimedia-${QTMIN}:5[qml]
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
"
RDEPEND="${DEPEND}
	>=dev-qt/qtsvg-${QTMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
"
BDEPEND=">=kde-frameworks/ki18n-${KFMIN}:5"
