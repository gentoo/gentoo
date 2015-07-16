# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-frameworks/kbookmarks/kbookmarks-5.12.0.ebuild,v 1.1 2015/07/16 20:33:14 johu Exp $

EAPI=5

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework for managing bookmarks stored in XBEL format"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}
	$(add_frameworks_dep kconfigwidgets)
	nls? ( dev-qt/linguist-tools:5 )
"
