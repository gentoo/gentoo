# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="KDE Telepathy contact, presence and chat Plasma applets"
HOMEPAGE="https://community.kde.org/Real-Time_Communication_and_Collaboration"

LICENSE="|| ( GPL-2 GPL-3 ) GPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep plasma)
	$(add_qt_dep qtdeclarative)
"
RDEPEND="${DEPEND}
	!kde-apps/ktp-desktop-applets:4
"
