# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.4
inherit ecm frameworks.kde.org

DESCRIPTION="Style for QtQuickControls 2 that uses QWidget's QStyle for painting"

LICENSE="|| ( GPL-2+ LGPL-3+ )"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5=
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	=kde-frameworks/kconfigwidgets-${PVCUT}*:5
	=kde-frameworks/kiconthemes-${PVCUT}*:5
	=kde-frameworks/kirigami-${PVCUT}*:5
	=kde-frameworks/sonnet-${PVCUT}*:5[qml]
"
RDEPEND="${DEPEND}
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
"

PATCHES=(
	"${FILESDIR}/${P}-fix-menubar-theme.patch" # KDE-bug #456729
	"${FILESDIR}/${P}-drop-layout-direction-hack.patch" # mirror fix in breeze 5.24.6-r1
	"${FILESDIR}/${P}-fix-precision.patch" # KDE-bug #455339
	"${FILESDIR}/${P}-strip-out-apersands.patch" # KDE-bug #457079
)
