# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic

DESCRIPTION="Hot backup utility for MySQL based servers"
HOMEPAGE="https://www.percona.com/software/mysql-database/percona-xtrabackup"
SRC_URI="https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-${PV}/source/tarball/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-arch/lz4:0=
	app-editors/vim-core
	>=dev-libs/boost-1.59.0:=
	dev-libs/libaio
	dev-libs/libedit
	dev-libs/libev
	dev-libs/libevent:0=
	dev-libs/libgcrypt:0=
	dev-libs/libgpg-error
	dev-python/sphinx
	net-misc/curl
	sys-libs/zlib"
RDEPEND="${DEPEND}
	!dev-db/xtrabackup-bin
	dev-perl/DBD-mysql"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.6-remove-boost-version-check.patch
	"${FILESDIR}"/${PN}-2.4.6-fix-gcc6-isystem.patch
)

src_prepare() {
	cmake-utils_src_prepare

	# remove bundled lz4, boost, libedit, libevent, zlib
	# just to be safe...
	rm -r extra/lz4 include/boost_1_59_0 \
		cmd-line-utils/libedit libevent zlib || die
}

src_configure() {
	# Needed, due to broken handling of CMAKE_BUILD_TYPE leading to
	#
	#   error: 'fts_ast_node_type_get' was not declared in this scope
	#
	append-cppflags -DDBUG_OFF

	local mycmakeargs=(
		-DBUILD_CONFIG=xtrabackup_release
		-DWITH_EDITLINE=system
		-DWITH_LIBEVENT=system
		-DWITH_LZ4=system
		-DWITH_SSL=bundled # uses yassl, which isn't packaged
		-DWITH_ZLIB=system
		-DWITH_PIC=ON
	)
	cmake-utils_src_configure
}

src_install() {
	local p="${BUILD_DIR}/storage/innobase/xtrabackup"

	dobin "${p}"/src/{xbcloud,xbcrypt,xbstream,xtrabackup}
	dosym xtrabackup /usr/bin/innobackupex

	einstalldocs
	doman "${p}"/doc/source/build/man/*
}
