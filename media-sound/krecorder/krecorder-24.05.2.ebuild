# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="utilities"
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Convergent audio recording application for Plasma"
HOMEPAGE="https://apps.kde.org/krecorder/"

LICENSE="CC0-1.0 CC-BY-4.0 GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

DEPEND="
	dev-libs/kirigami-addons:6
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtmultimedia-${QTMIN}:6[qml]
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
"
RDEPEND="${DEPEND}
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
"
BDEPEND=">=kde-frameworks/ki18n-${KFMIN}:6"
