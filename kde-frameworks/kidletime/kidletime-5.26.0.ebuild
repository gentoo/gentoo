# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_TEST="false"
inherit kde5

DESCRIPTION="Framework for detection and notification of device idle time"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXext
	x11-libs/libxcb
"
DEPEND="${RDEPEND}"
