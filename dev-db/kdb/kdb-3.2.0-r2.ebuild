# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
PYTHON_COMPAT=( python3_{8..10} )
KFMIN=5.82.0
QTMIN=5.15.2
inherit ecm kde.org python-any-r1

DESCRIPTION="Database connectivity and creation framework for various vendors"
HOMEPAGE="https://community.kde.org/KDb"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/src/${P}.tar.xz
	https://dev.gentoo.org/~asturm/distfiles/${P}-patches.tar.xz"
	KEYWORDS="amd64 x86"
fi

LICENSE="LGPL-2+"
SLOT="5/4"
IUSE="debug mysql postgres sqlite"

DEPEND="
	dev-libs/icu:=
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	mysql? ( dev-db/mysql-connector-c:= )
	postgres? (
		dev-db/postgresql:*
		>=dev-qt/qtnetwork-${QTMIN}:5
	)
	sqlite? ( dev-db/sqlite:3 )
"
RDEPEND="${DEPEND}"
BDEPEND="${PYTHON_DEPS}
	dev-qt/linguist-tools:5
"

PATCHES=(
	# 3.2 branch
	"${WORKDIR}"/${P}-patches/${P}-build-w-pg12.patch
	"${WORKDIR}"/${P}-patches/${P}-qt-5.15.patch
	"${WORKDIR}"/${P}-patches/${P}-cmake-pg15.patch
	"${WORKDIR}"/${P}-patches/${P}-Q_REQUIRED_RESULT-placing.patch
	"${WORKDIR}"/${P}-patches/${P}-gcc12.patch
	# master
	"${WORKDIR}"/${P}-patches/${P}-KDEInstallDirs.patch
	"${FILESDIR}"/${P}-postgresql-gcc12.patch # bug 869368
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
