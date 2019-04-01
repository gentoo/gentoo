# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="kde_cdemu"
inherit kde5

DESCRIPTION="Frontend to cdemu daemon based on KDE Frameworks"
HOMEPAGE="https://www.linux-apps.com/p/998461/"
SRC_URI="https://dl.opendesktop.org/api/files/downloadfile/id/1511553040/o/1/s/3e4f95734673128605fc1d8721894a1c/t/1517011407/u/65804/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}
	>=app-cdr/cdemu-2.0.0[cdemu-daemon]
"

S="${WORKDIR}/${MY_PN}"
