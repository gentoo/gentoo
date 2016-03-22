# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_PUNT_BOGUS_DEPS="true"
inherit kde5

DESCRIPTION="Library for providing abstractions to get the developer's purposes fulfilled"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_kdeapps_dep kaccounts-integration)
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	net-libs/accounts-qt
"
RDEPEND="${DEPEND}"
