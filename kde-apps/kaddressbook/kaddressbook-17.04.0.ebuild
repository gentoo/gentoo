# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional" # FIXME: Check back for doc in release
KDE_TEST="forceoptional-recursive"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Address book application based on KDE Frameworks"
HOMEPAGE="https://www.kde.org/applications/office/kaddressbook/"
LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="prison"

COMMON_DEPEND="
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep akonadi)
	$(add_kdeapps_dep akonadi-contacts)
	$(add_kdeapps_dep akonadi-search)
	$(add_kdeapps_dep grantleetheme)
	$(add_kdeapps_dep kcontacts)
	$(add_kdeapps_dep kdepim-apps-libs)
	$(add_kdeapps_dep kontactinterface)
	$(add_kdeapps_dep libgravatar)
	$(add_kdeapps_dep libkdepim)
	$(add_kdeapps_dep pimcommon)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtwidgets)
	>=app-crypt/gpgme-1.7.1[cxx,qt5]
	dev-libs/grantlee:5
	prison? ( $(add_frameworks_dep prison) )
"
DEPEND="${COMMON_DEPEND}
	test? ( $(add_kdeapps_dep akonadi 'sqlite,tools') )
"
RDEPEND="${COMMON_DEPEND}
	$(add_kdeapps_dep kdepim-runtime)
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package prison KF5Prison)
	)

	kde5_src_configure
}
