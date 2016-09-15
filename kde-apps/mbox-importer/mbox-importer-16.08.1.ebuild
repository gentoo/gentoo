# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="forceoptional" # FIXME: Check back for doc in release
KMNAME="kdepim"
MY_PN="mboximporter"
inherit kde5

DESCRIPTION="Import mbox email archives from various sources into Akonadi"
LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_kdeapps_dep akonadi)
	$(add_kdeapps_dep kidentitymanagement)
	$(add_kdeapps_dep mailcommon)
	$(add_kdeapps_dep mailimporter)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim:5
	!kde-apps/kmail:4
"

if [[ ${KDE_BUILD_TYPE} = live ]] ; then
	S="${WORKDIR}/${P}/${MY_PN}"
else
	S="${WORKDIR}/${KMNAME}-${PV}/${MY_PN}"
fi
