# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ECM_HANDBOOK="true"
ECM_TEST="forceoptional"
KFMIN=5.82.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Visual database applications creator"
HOMEPAGE="https://apps.kde.org/kexi-3.3/ https://kexi-project.org/
https://userbase.kde.org/Kexi"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/${PN}/src/${P}.tar.xz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
IUSE="debug experimental marble mdb mysql postgres sqlite"

DEPEND="
	>=dev-db/kdb-3.1.0-r1:5=[debug?,mysql?,postgres?,sqlite?]
	>=dev-libs/kproperty-3.1.0:5=
	>=dev-libs/kreport-3.1.0:5=[scripting]
	>=dev-qt/designer-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/breeze-icons-rcc-${KFMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/ktexteditor-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	marble? ( kde-apps/marble:5= )
	mdb? (
		dev-libs/glib:2
		virtual/libiconv
	)
	mysql? ( dev-db/mysql-connector-c:= )
	postgres? (
		dev-db/postgresql:*
		dev-libs/libpqxx
	)
"
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${P}-missing-header.patch
	"${FILESDIR}"/${P}-postgresql-9.14.patch
	"${FILESDIR}"/${P}-glib-2.68.patch # bug 784974
	"${FILESDIR}"/${P}-fix-find-marble.patch # bug 812392
)

src_prepare() {
	ecm_punt_qt_module WebKit
	ecm_punt_qt_module WebKitWidgets

	ecm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DKEXI_MIGRATEMANAGER_DEBUG=$(usex debug)
		-DKEXI_AUTORISE_TABBED_TOOLBAR=$(usex experimental)
		-DKEXI_SCRIPTS_SUPPORT=$(usex experimental)
		$(cmake_use_find_package marble Marble)
		$(cmake_use_find_package mdb GLIB2)
		$(cmake_use_find_package mysql MySQL)
		$(cmake_use_find_package postgres PostgreSQL)
	)
	use experimental && mycmakeargs+=( -DKEXI_SCRIPTING_DEBUG=$(usex debug) )

	ecm_src_configure
}
