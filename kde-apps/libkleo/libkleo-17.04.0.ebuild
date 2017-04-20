# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="false"
inherit kde5

DESCRIPTION="Library for encryption handling"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_kdeapps_dep kpimtextedit)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	>=app-crypt/gpgme-1.7.1[cxx,qt5]
"
DEPEND="${RDEPEND}
	dev-libs/boost
"
