# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-plasma/plasma-sdk/plasma-sdk-5.3.2.ebuild,v 1.2 2015/07/06 15:35:07 kensington Exp $

EAPI=5

KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Useful applications for Plasma development"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kpackage)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep plasma)
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
RDEPEND="${DEPEND}
	!dev-util/plasmate
"
