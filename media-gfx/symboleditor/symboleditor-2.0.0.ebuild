# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_DOXYGEN="true"
KDE_HANDBOOK="true"
inherit kde5

DESCRIPTION="Application to create libraries of QPainterPath objects with redering hints"
HOMEPAGE="https://userbase.kde.org/SymbolEditor"
if [[ ${KDE_BUILD_TYPE} != live ]]; then
	MY_P=SymbolEditor-${PV}
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${MY_P}.tar.bz2"
	S="${WORKDIR}"/${MY_P}
fi

LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	x11-misc/shared-mime-info
"
RDEPEND="${COMMON_DEPEND}
	!media-gfx/symboleditor:4
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package doc Doxygen)
		$(cmake-utils_use_find_package handbook KF5DocTools)
	)

	kde5_src_configure
}
