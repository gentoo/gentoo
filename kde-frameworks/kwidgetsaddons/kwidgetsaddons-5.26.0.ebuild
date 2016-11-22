# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="An assortment of high-level widgets for common tasks"
LICENSE="LGPL-2.1+"
KEYWORDS="amd64 ~arm x86"
IUSE="nls"

RDEPEND="
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
DEPEND="${RDEPEND}
	nls? ( $(add_qt_dep linguist-tools) )
	test? ( $(add_qt_dep designer) )
"
