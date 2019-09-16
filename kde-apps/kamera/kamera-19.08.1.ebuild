# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Plasma integration for gphoto2 cameras"
LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

BDEPEND="
	sys-devel/gettext
"
DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	media-libs/libgphoto2:=
"
RDEPEND="${DEPEND}"
