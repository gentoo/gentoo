# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="KDE Telepathy krunner plugin"
HOMEPAGE="https://community.kde.org/Real-Time_Communication_and_Collaboration"

LICENSE="LGPL-2.1"
KEYWORDS=" ~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep krunner)
	$(add_kdeapps_dep ktp-common-internals)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	net-libs/telepathy-qt[qt5]
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kservice)
"
RDEPEND="${COMMON_DEPEND}
	!net-im/ktp-contact-runner
"
