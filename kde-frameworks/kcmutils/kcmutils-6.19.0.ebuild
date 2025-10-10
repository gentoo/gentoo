# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework to work with KDE System Settings modules"

LICENSE="LGPL-2"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6[widgets]
	=kde-frameworks/kconfig-${KDE_CATV}*:6
	=kde-frameworks/kconfigwidgets-${KDE_CATV}*:6
	=kde-frameworks/kcoreaddons-${KDE_CATV}*:6
	=kde-frameworks/kguiaddons-${KDE_CATV}*:6
	=kde-frameworks/ki18n-${KDE_CATV}*:6
	=kde-frameworks/kio-${KDE_CATV}*:6
	=kde-frameworks/kitemviews-${KDE_CATV}*:6
	=kde-frameworks/kwidgetsaddons-${KDE_CATV}*:6
	=kde-frameworks/kxmlgui-${KDE_CATV}*:6
"
RDEPEND="${DEPEND}"
