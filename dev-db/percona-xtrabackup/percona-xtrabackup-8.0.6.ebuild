# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake-utils flag-o-matic

DESCRIPTION="Hot backup utility for MySQL based servers"
HOMEPAGE="https://www.percona.com/software/mysql-database/percona-xtrabackup"
SRC_URI="https://www.percona.com/downloads/Percona-XtraBackup-LATEST/Percona-XtraBackup-8.0-6/source/tarball/${P}.tar.gz
	mirror://sourceforge/boost/boost_1_68_0.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	app-arch/lz4:0=
	app-editors/vim-core
	dev-libs/icu:=
	dev-libs/libaio
	dev-libs/libedit
	dev-libs/libev
	dev-libs/libevent:0=
	dev-libs/libgcrypt:0=
	dev-libs/libgpg-error
	dev-libs/protobuf:=
	dev-libs/rapidjson
	dev-libs/re2:=
	dev-python/sphinx
	net-misc/curl
	sys-libs/zlib:="

RDEPEND="
	${DEPEND}
	!dev-db/percona-xtrabackup-bin
	dev-perl/DBD-mysql"

src_configure() {
	local mycmakeargs=(
		-DBUILD_CONFIG=xtrabackup_release
		-DBUILD_SHARED_LIBS=OFF
		-DWITH_BOOST="${WORKDIR}/boost_1_68_0"
		-DWITH_SYSTEM_LIBS=ON
	)
	local CMAKE_BUILD_TYPE="Release"
	cmake-utils_src_configure
}

src_install() {
	local p="${BUILD_DIR}/storage/innobase/xtrabackup"

	dobin "${p}"/xbcloud_osenv
	dobin "${BUILD_DIR}"/runtime_output_directory/{xbcloud,xbcrypt,xbstream,xtrabackup}

	doman "${p}"/doc/source/build/man/*
}
