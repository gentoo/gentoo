# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_EXAMPLES="true"
KDE_QTHELP="true"
KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	KEYWORDS="amd64 arm64 x86"
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
fi

DESCRIPTION="Powerful libraries (KChart, KGantt) for creating business diagrams"
HOMEPAGE="https://kde.org/ https://www.kdab.com/development-resources/qt-tools/kd-chart/"
IUSE=""

REQUIRED_USE="test? ( examples )"

BDEPEND="
	$(add_qt_dep linguist-tools)
"
DEPEND="
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-fix-horizontal-bars.patch" )
