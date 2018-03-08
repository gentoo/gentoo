# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="Qt Quick plugin for beautiful and interactive charts"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
"
RDEPEND="${DEPEND}"
