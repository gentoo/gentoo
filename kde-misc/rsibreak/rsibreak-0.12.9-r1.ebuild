# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Small utility which bothers you at certain intervals"
HOMEPAGE="https://userbase.kde.org/RSIBreak"
if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/$(ver_cut 1-2)/${P}.tar.xz"
fi

LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
KEYWORDS="amd64 x86"
IUSE=""

BDEPEND="sys-devel/gettext"
DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kidletime)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
# bug 587170 for frameworkintegration
RDEPEND="${DEPEND}
	$(add_frameworks_dep frameworkintegration)
	!kde-misc/rsibreak:4
"
