# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_EXAMPLES="true"
KDE_TEST="forceoptional-recursive"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Plugins for KDE Personal Information Management Suite"
HOMEPAGE="https://www.kde.org/applications/office/kontact/"
LICENSE="GPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 ~x86"

IUSE="google"

COMMON_DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep khtml)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep akonadi)
	$(add_kdeapps_dep akonadi-notes)
	$(add_kdeapps_dep calendarsupport)
	$(add_kdeapps_dep eventviews)
	$(add_kdeapps_dep grantleetheme)
	$(add_kdeapps_dep incidenceeditor)
	$(add_kdeapps_dep kcontacts)
	$(add_kdeapps_dep kdepim-apps-libs)
	$(add_kdeapps_dep kidentitymanagement)
	$(add_kdeapps_dep kmime)
	$(add_kdeapps_dep libkdepim)
	$(add_kdeapps_dep libkleo)
	$(add_kdeapps_dep libktnef)
	$(add_kdeapps_dep mailcommon)
	$(add_kdeapps_dep messagelib)
	$(add_kdeapps_dep pimcommon)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	google? ( $(add_kdeapps_dep libkgapi '' 5.3.1) )
"
DEPEND="${COMMON_DEPEND}
	>=app-crypt/gpgme-1.7.1[cxx,qt5]
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/kaddressbook:4
	!kde-apps/kmail:4
"

RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		-DKDEPIMADDONS_BUILD_EXAMPLES=$(usex examples)
		$(cmake-utils_use_find_package google KF5GAPI)
	)

	kde5_src_configure
}
