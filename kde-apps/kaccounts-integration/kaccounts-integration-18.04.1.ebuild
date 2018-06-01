# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="forceoptional"
VIRTUALDBUS_TEST="true"
inherit kde5

DESCRIPTION="Administer web accounts for the sites and services across the Plasma desktop"
HOMEPAGE="https://community.kde.org/KTp"
LICENSE="LGPL-2.1"

KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	net-libs/accounts-qt
	>=net-libs/libaccounts-glib-1.21
	net-libs/signond
"
DEPEND="${RDEPEND}
	$(add_frameworks_dep kcmutils)
	$(add_plasma_dep kde-cli-tools)
	sys-devel/gettext
"

# bug #549444
RESTRICT+=" test"
