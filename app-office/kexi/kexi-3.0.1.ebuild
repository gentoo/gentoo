# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# KDE_HANDBOOK="true"
KDE_TEST="forceoptional"
inherit kde5

DESCRIPTION="Visual database applications creator"
HOMEPAGE="https://www.kde.org/applications/office/kexi/ http://www.kexi-project.org/"
[[ ${KDE_BUILD_TYPE} != live ]] && SRC_URI="mirror://kde/stable/${PN}/src/${P}.tar.xz"

KEYWORDS="~amd64 ~x86"
IUSE="marble mdb mysql postgres sqlite webkit"

COMMON_DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep designer)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-db/kdb[mysql?,postgres?,sqlite?]
	dev-libs/kproperty
	dev-libs/kreport
	marble? ( $(add_kdeapps_dep marble) )
	mdb? ( dev-libs/glib:2 )
	mysql? ( virtual/libmysqlclient )
	postgres? (
		dev-db/postgresql:*
		dev-libs/libpqxx
	)
	webkit? ( $(add_qt_dep qtwebkit) )
"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
"
RDEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep breeze-icons-rcc)
	!app-office/calligra:4[calligra_features_kexi]
	!app-office/calligra-l10n:4[calligra_features_kexi(+)]
"

src_prepare() {
	if ! use webkit; then
		punt_bogus_dep Qt5 WebKit
		punt_bogus_dep Qt5 WebKitWidgets
	fi

	kde5_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package marble KexiMarble)
		$(cmake-utils_use_find_package mdb GLIB2)
		$(cmake-utils_use_find_package mysql MySQL)
		$(cmake-utils_use_find_package postgres KexiPostgreSQL)
	)
	kde5_src_configure
}
