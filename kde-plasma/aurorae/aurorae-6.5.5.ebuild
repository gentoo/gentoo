# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.18.0
QTMIN=6.10.1
inherit ecm plasma.kde.org

DESCRIPTION="Themeable window decoration for KWin"
HOMEPAGE="https://invent.kde.org/plasma/aurorae"

LICENSE="GPL-2+ MIT"
SLOT="6"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,opengl,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qttools-${QTMIN}:6[widgets]
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/kpackage-${KFMIN}:6
	>=kde-plasma/kdecoration-${PV}:6
"
RDEPEND="${DEPEND}
	!<kde-plasma/kwin-6.3.2
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/ksvg-${KFMIN}:6
"

DOCS=( README )
