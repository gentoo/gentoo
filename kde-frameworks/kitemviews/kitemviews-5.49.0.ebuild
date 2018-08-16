# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework providing additional widgets for item models"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="nls"

RDEPEND="
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
DEPEND="${RDEPEND}
	nls? ( $(add_qt_dep linguist-tools) )
"
