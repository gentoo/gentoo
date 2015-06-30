# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-plasma/libkscreen/libkscreen-5.3.2.ebuild,v 1.1 2015/06/30 20:50:13 johu Exp $

EAPI=5

KDE_PUNT_BOGUS_DEPS="true"
KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="KDE screen management library"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtx11extras:5
	x11-libs/libxcb
"
RDEPEND="${DEPEND}
	!x11-libs/libkscreen:5
"
