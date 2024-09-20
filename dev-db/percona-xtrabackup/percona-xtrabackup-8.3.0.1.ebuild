# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake flag-o-matic

MY_PV=$(ver_rs 3 '-')
MY_PV="${MY_PV//_pre*}"
MY_PN="Percona-XtraBackup"
MY_P="${PN}-${MY_PV}"
MY_MAJOR_PV=$(ver_cut 1-2)

DESCRIPTION="Hot backup utility for MySQL based servers"
HOMEPAGE="https://www.percona.com/software/mysql-database/percona-xtrabackup"
SRC_URI="
	https://downloads.percona.com/downloads/${MY_PN}-innovative-release/${MY_PN}-${MY_PV}/source/tarball/${PN}-${MY_PV}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	app-arch/lz4:0=
	app-arch/zstd:=
	app-editors/vim-core
	dev-libs/icu:=
	dev-libs/libaio
	dev-libs/libedit
	dev-libs/libev
	dev-libs/libevent:0=
	dev-libs/libfido2:=
	dev-libs/libgcrypt:0=
	dev-libs/libgpg-error
	dev-libs/openssl:0=
	dev-libs/protobuf:=
	dev-libs/re2:=
	dev-python/sphinx
	net-misc/curl
	sys-libs/zlib:=
	sys-process/procps:=
"

RDEPEND="
	${DEPEND}
	!dev-db/percona-xtrabackup-bin
	dev-perl/DBD-mysql"

PATCHES=(
	"${FILESDIR}"/${PN}-8.0.26-remove-rpm.patch
)

S="${WORKDIR}/percona-xtrabackup-${MY_PV}"

src_prepare() {
	cmake_src_prepare

	local extra
	# rapidjson: last released in 2016 and totally unviable to devendor
	# lz4: in storage/innobase/xtrabackup/src/CMakeLists.txt it is used even when =system
	for extra in curl icu libcbor libedit libevent libfido2 zlib zstd; do
		rm -r "extra/${extra}/" || die "failed to remove bundled libs"
	done
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/855245
	# https://perconadev.atlassian.net/browse/PXB-3345
	filter-lto

	CMAKE_BUILD_TYPE="RelWithDebInfo"

	local mycmakeargs=(
		-DCMAKE_C_FLAGS_RELWITHDEBINFO=-DNDEBUG
		-DCMAKE_CXX_FLAGS_RELWITHDEBINFO=-DNDEBUG
		-DBUILD_SHARED_LIBS=OFF
		-DCOMPILATION_COMMENT="Gentoo Linux ${PF}"
		-DINSTALL_PLUGINDIR=$(get_libdir)/${PN}/plugin
		-DWITH_MAN_PAGES=ON
		-DWITH_SYSTEM_LIBS=ON
		# not handled via SYSTEM_LIBS
		-DWITH_ZLIB=system
	)

	cmake_src_configure
}

src_install() {
	local p="${BUILD_DIR}/storage/innobase/xtrabackup"

	dobin "${p}"/xbcloud_osenv
	dobin "${BUILD_DIR}"/runtime_output_directory/{xbcloud,xbcrypt,xbstream,xtrabackup}

	# cannot use dolib.so because helper would append libdir to target dir
	insinto /usr/$(get_libdir)/${PN}/plugin
	insopts -m 0755
	doins "${BUILD_DIR}"/plugin_output_directory/*

	doman "${p}"/doc/source/build/man/*
}
