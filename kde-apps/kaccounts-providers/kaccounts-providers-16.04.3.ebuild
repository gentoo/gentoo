# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="KDE accounts providers"
HOMEPAGE="https://community.kde.org/KTp"
LICENSE="LGPL-2.1"

KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEPEND="
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
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
"
RDEPEND="${COMMON_DEPEND}
	net-im/telepathy-connection-managers[xmpp]
	net-libs/signon-ui
	net-libs/signon-oauth2
"
