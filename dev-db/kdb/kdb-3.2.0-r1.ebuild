# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_QTHELP="true"
ECM_TEST="true"
PYTHON_COMPAT=( python3_{7,8,9} )
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org python-any-r1

DESCRIPTION="Database connectivity and creation framework for various vendors"
HOMEPAGE="https://community.kde.org/KDb"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/src/${P}.tar.xz"
	KEYWORDS="amd64 x86"
fi

LICENSE="LGPL-2+"
SLOT="5/4"
IUSE="debug mysql postgres sqlite"

BDEPEND="${PYTHON_DEPS}
	dev-qt/linguist-tools:5
"
DEPEND="
	dev-libs/icu:=
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	mysql? ( dev-db/mysql-connector-c:= )
	postgres? (
		>=dev-qt/qtnetwork-${QTMIN}:5
		dev-db/postgresql:*
	)
	sqlite? ( dev-db/sqlite:3 )
"
RDEPEND="${DEPEND}"

PATCHES=(
	# 3.2 branch
	"${FILESDIR}"/${P}-cmake-pg12.patch
	"${FILESDIR}"/${P}-build-w-pg12.patch
	"${FILESDIR}"/${P}-cmake-pg13.patch
	"${FILESDIR}"/${P}-qt-5.15.patch
	# master
	"${FILESDIR}"/${P}-KDEInstallDirs.patch
)

pkg_setup() {
	python-any-r1_pkg_setup
	ecm_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DKDB_DEBUG_GUI=$(usex debug)
		$(cmake_use_find_package mysql MySQL)
		$(cmake_use_find_package postgres PostgreSQL)
		$(cmake_use_find_package sqlite Sqlite)
	)

	ecm_src_configure
}
