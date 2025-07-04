# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="utilities"
KFMIN=6.13.0
QTMIN=6.7.2
inherit ecm gear.kde.org xdg

DESCRIPTION="Convergent audio recording application for Plasma"
HOMEPAGE="https://apps.kde.org/krecorder/"

LICENSE="CC0-1.0 CC-BY-4.0 GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv ~x86"

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
