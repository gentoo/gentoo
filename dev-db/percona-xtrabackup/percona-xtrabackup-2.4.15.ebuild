# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake flag-o-matic

DESCRIPTION="Hot backup utility for MySQL based servers"
HOMEPAGE="https://www.percona.com/software/mysql-database/percona-xtrabackup"
SRC_URI="https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-${PV}/source/tarball/${P}.tar.gz
	mirror://sourceforge/boost/boost_1_59_0.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	app-arch/lz4:0=
	app-editors/vim-core
	dev-libs/libaio
	dev-libs/libedit
	dev-libs/libev
	dev-libs/libevent:0=
	dev-libs/libgcrypt:0=
	dev-libs/libgpg-error
	dev-python/sphinx
	net-misc/curl
	sys-libs/zlib:="

RDEPEND="
	${DEPEND}
	!dev-db/percona-xtrabackup-bin
	dev-perl/DBD-mysql"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.6-remove-boost-version-check.patch
	"${FILESDIR}"/${PN}-2.4.11-fix-gcc6-isystem.patch
)

src_prepare() {
	cmake_src_prepare

	# remove bundled libedit, libevent, zlib
	# just to be safe...
	# We keep lz4 directory because we use extra/lz4/xxhash.c in cmake/libutils.cmake
	rm -rv \
		cmd-line-utils/libedit \
		libevent \
		zlib || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CONFIG=xtrabackup_release
		-DBUILD_SHARED_LIBS=OFF
		-DWITH_BOOST="${WORKDIR}/boost_1_59_0"
		-DWITH_EDITLINE=system
		-DWITH_LIBEVENT=system
		-DWITH_LZ4=system
		-DWITH_SSL=bundled # uses yassl, which isn't packaged
		-DWITH_ZLIB=system
		-DWITH_PIC=ON
	)

	local CMAKE_BUILD_TYPE="Release"
	cmake_src_configure
}

src_install() {
	local p="${BUILD_DIR}/storage/innobase/xtrabackup"

	dobin "${p}"/src/{xbcloud/xbcloud,xbcrypt,xbstream,xtrabackup}
	dosym xtrabackup /usr/bin/innobackupex

	einstalldocs
	doman "${p}"/doc/source/build/man/*
}
