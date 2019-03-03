# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="kde_cdemu"
SOME_HASH="efbd90bba65c0b58a15865dda8288e87a635d59a1da0b465424c26601f37166aba223d0258de7fb79462dcb182c0b359f0cb9533e076d313b21850152aa6207c"
inherit kde5

DESCRIPTION="Frontend to cdemu daemon based on KDE Frameworks"
HOMEPAGE="https://www.linux-apps.com/p/998461/"
SRC_URI="https://dl.opendesktop.org/api/files/download/id/1511553040/s/${SOME_HASH}/t/1551656655/u//${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
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
