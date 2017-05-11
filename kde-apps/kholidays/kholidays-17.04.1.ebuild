# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="true"
inherit kde5

DESCRIPTION="Library to determine holidays and other special events for a geographical region"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="nls"

RDEPEND="
	$(add_qt_dep qtdeclarative)
"
DEPEND="${RDEPEND}
	nls? ( $(add_qt_dep linguist-tools) )
"
