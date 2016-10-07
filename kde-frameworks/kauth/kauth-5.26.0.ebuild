# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework to let applications perform actions as a privileged user"
LICENSE="LGPL-2.1+"
KEYWORDS="amd64 ~arm x86"
IUSE="nls +policykit"

# drop qtgui subslot operator when QT_MINIMAL >= 5.7.0
RDEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_qt_dep qtdbus '' '' '5=')
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	policykit? ( sys-auth/polkit-qt[qt5] )
"
DEPEND="${RDEPEND}
	nls? ( $(add_qt_dep linguist-tools) )
"
PDEPEND="policykit? ( kde-plasma/polkit-kde-agent )"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package policykit PolkitQt5-1)
	)

	kde5_src_configure
}
