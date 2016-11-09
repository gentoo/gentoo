# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit kde5 python-any-r1

DESCRIPTION="Database connectivity and creation framework for various vendors"
[[ ${KDE_BUILD_TYPE} != live ]] && SRC_URI="mirror://kde/stable/${PN}/src/${P}.tar.xz"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="mysql postgres sqlite"

RDEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-libs/icu:=
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( dev-db/sqlite:3 )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package mysql MySQL)
		$(cmake-utils_use_find_package postgres PostgreSQL)
		$(cmake-utils_use_find_package sqlite Sqlite)
	)

	kde5_src_configure
}
