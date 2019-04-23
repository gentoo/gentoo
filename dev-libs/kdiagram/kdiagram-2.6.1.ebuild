# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_EXAMPLES="true"
KDE_QTHELP="true"
KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Powerful libraries (KChart, KGantt) for creating business diagrams"
HOMEPAGE="https://www.kde.org/"
IUSE=""

REQUIRED_USE="test? ( examples )"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	KEYWORDS="amd64 ~arm64 x86"
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
fi

RDEPEND="
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
"
DEPEND="${RDEPEND}
	$(add_qt_dep linguist-tools)
"
