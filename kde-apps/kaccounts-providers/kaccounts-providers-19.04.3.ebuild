# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="KDE accounts providers"
HOMEPAGE="https://community.kde.org/KTp"
LICENSE="LGPL-2.1"

KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

BDEPEND="
	dev-util/intltool
"
DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kpackage)
	$(add_kdeapps_dep kaccounts-integration)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtxml)
"
RDEPEND="${DEPEND}
	net-libs/signon-ui
	net-libs/signon-oauth2
"
