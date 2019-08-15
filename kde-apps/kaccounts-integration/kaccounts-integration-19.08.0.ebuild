# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="forceoptional"
VIRTUALDBUS_TEST="true"
inherit kde5

DESCRIPTION="Administer web accounts for the sites and services across the Plasma desktop"
HOMEPAGE="https://community.kde.org/KTp"
LICENSE="LGPL-2.1"

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

BDEPEND="
	sys-devel/gettext
"
COMMON_DEPEND="
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
	>=net-libs/libaccounts-glib-1.21:=
	net-libs/signond
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kcmutils)
	$(add_plasma_dep kde-cli-tools)
"
RDEPEND="${COMMON_DEPEND}
	dev-util/intltool
"

# bug #549444
RESTRICT+=" test"
