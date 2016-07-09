# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework for converting text emoticons to graphical representations"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kservice)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtxml)
"
DEPEND="${RDEPEND}"

# requires running kde environment
RESTRICT="test"
