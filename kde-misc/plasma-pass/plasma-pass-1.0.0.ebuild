# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="Plasma applet to access password from pass"
HOMEPAGE="https://www.dvratil.cz/2018/05/plasma-pass/ https://cgit.kde.org/plasma-pass.git/"

if [[ ${KDE_BUILD_TYPE} != live ]] ; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="amd64"
fi

LICENSE="LGPL-2.1+"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep plasma)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgraphicaleffects)
	$(add_qt_dep qtgui)
"
RDEPEND="${DEPEND}
	$(add_frameworks_dep kirigami)
"
