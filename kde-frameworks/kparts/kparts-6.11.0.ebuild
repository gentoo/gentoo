# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing elaborate user-interface components"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets,xml]
	=kde-frameworks/kconfig-${KDE_CATV}*:6
	=kde-frameworks/kcoreaddons-${KDE_CATV}*:6
	=kde-frameworks/ki18n-${KDE_CATV}*:6
	=kde-frameworks/kiconthemes-${KDE_CATV}*:6
	=kde-frameworks/kio-${KDE_CATV}*:6
	=kde-frameworks/kjobwidgets-${KDE_CATV}*:6
	=kde-frameworks/kservice-${KDE_CATV}*:6
	=kde-frameworks/kwidgetsaddons-${KDE_CATV}*:6
	=kde-frameworks/kxmlgui-${KDE_CATV}*:6
"
DEPEND="${RDEPEND}"
