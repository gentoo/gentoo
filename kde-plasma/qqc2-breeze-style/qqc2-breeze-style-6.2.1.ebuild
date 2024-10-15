# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="false"
KFMIN=6.5.0
QTMIN=6.7.2
inherit ecm plasma.kde.org

DESCRIPTION="Breeze inspired QQC2 Style"

LICENSE="|| ( GPL-2+ LGPL-3+ ) CC0-1.0"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kquickcharts-${KFMIN}:6
"
RDEPEND="${DEPEND}"
