# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="Powerful libraries (KChart, KGantt) for creating business diagrams"
HOMEPAGE="https://www.kde.org/"
IUSE=""

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	KEYWORDS="~amd64 ~x86"
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"
fi

DEPEND="
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}"
