# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_BLOCK_SLOT4="false"
inherit kde5

DESCRIPTION="SANE Library interface for KDE"
KEYWORDS="amd64 x86"
IUSE=""
LICENSE="LGPL-2"

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	media-gfx/sane-backends
"
RDEPEND="${DEPEND}"
