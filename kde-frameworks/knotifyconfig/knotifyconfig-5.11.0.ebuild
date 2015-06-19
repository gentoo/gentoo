# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-frameworks/knotifyconfig/knotifyconfig-5.11.0.ebuild,v 1.1 2015/06/15 18:35:11 kensington Exp $

EAPI=5

KDE_TEST="false"
inherit kde5

DESCRIPTION="Framework for configuring desktop notifications"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="phonon"

RDEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	phonon? ( media-libs/phonon[qt5] )
"
DEPEND="${RDEPEND}"
