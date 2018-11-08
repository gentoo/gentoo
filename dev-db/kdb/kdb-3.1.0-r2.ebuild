# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit kde5 python-any-r1

DESCRIPTION="Database connectivity and creation framework for various vendors"
[[ ${KDE_BUILD_TYPE} != live ]] && SRC_URI="mirror://kde/stable/${PN}/src/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="5/4"
KEYWORDS="amd64 x86"
IUSE="debug mysql postgres sqlite"

RDEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-libs/icu:=
	mysql? ( dev-db/mysql-connector-c:= )
	postgres? (
		$(add_qt_dep qtnetwork)
		dev-db/postgresql:*
	)
	sqlite? ( dev-db/sqlite:3 )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-qt/linguist-tools:5
"

PATCHES=(
	"${FILESDIR}/${P}-crashfix.patch"
	"${FILESDIR}/${P}-fix-loading-objdata.patch"
	"${FILESDIR}/${P}-postgresql-11.patch"
)

pkg_setup() {
	python-any-r1_pkg_setup
	kde5_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DKDB_DEBUG_GUI=$(usex debug)
		$(cmake-utils_use_find_package mysql MySQL)
		$(cmake-utils_use_find_package postgres PostgreSQL)
		$(cmake-utils_use_find_package sqlite Sqlite)
	)

	kde5_src_configure
}
