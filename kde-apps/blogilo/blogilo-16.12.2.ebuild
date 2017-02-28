# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
inherit kde5

DESCRIPTION="Application to create, edit and update blog content"
HOMEPAGE="https://www.kde.org/applications/internet/blogilo"
LICENSE="GPL-2+ LGPL-2.1+ handbook? ( FDL-1.2+ )"
KEYWORDS="~amd64 ~x86"

IUSE="google"

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep kblog)
	$(add_kdeapps_dep kdepim-apps-libs)
	$(add_kdeapps_dep libkdepim)
	$(add_kdeapps_dep messagelib)
	$(add_kdeapps_dep pimcommon)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtwebengine 'widgets')
	$(add_qt_dep qtwidgets)
	google? ( $(add_kdeapps_dep libkgapi '' 5.3.1) )
"
RDEPEND="${DEPEND}
	!<kde-apps/kdepim-apps-libs-16.04.50
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package google KF5GAPI)
	)

	kde5_src_configure
}
