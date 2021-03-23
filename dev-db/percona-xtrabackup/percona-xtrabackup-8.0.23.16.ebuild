# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake flag-o-matic

MY_BOOST_VERSION="1.73.0"
MY_PV=$(ver_rs 3 '-')
MY_PV="${MY_PV//_pre*}"
MY_PN="Percona-XtraBackup"
MY_P="${PN}-${MY_PV}"
MY_MAJOR_PV=$(ver_cut 1-2)

DESCRIPTION="Hot backup utility for MySQL based servers"
HOMEPAGE="https://www.percona.com/software/mysql-database/percona-xtrabackup"
SRC_URI="https://www.percona.com/downloads/${MY_PN}-${MY_MAJOR_PV}/${MY_PN}-${MY_PV}/source/tarball/${PN}-${MY_PV}.tar.gz
	https://dl.bintray.com/boostorg/release/${MY_BOOST_VERSION}/source/boost_$(ver_rs 1- _ ${MY_BOOST_VERSION}).tar.bz2
"

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
	dev-libs/openssl:0=
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

PATCHES=(
	"${FILESDIR}"/${PN}-8.0.22-remove-rpm.patch
	"${FILESDIR}"/${PN}-8.0.22-fix-building-against-ICU-68.patch
)

S="${WORKDIR}/percona-xtrabackup-${MY_PV}"

src_configure() {
	CMAKE_BUILD_TYPE="RelWithDebInfo"

	local mycmakeargs=(
		-DCMAKE_C_FLAGS_RELWITHDEBINFO=-DNDEBUG
		-DCMAKE_CXX_FLAGS_RELWITHDEBINFO=-DNDEBUG
		-DBUILD_SHARED_LIBS=OFF
		-DCOMPILATION_COMMENT="Gentoo Linux ${PF}"
		-DINSTALL_PLUGINDIR=$(get_libdir)/${PN}/plugin
		-DWITH_BOOST="${WORKDIR}/boost_$(ver_rs 1- _ ${MY_BOOST_VERSION})"
		-DWITH_MAN_PAGES=ON
		-DWITH_SYSTEM_LIBS=ON
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
	doins "${BUILD_DIR}"/plugin_output_directory/{keyring_file.so,keyring_vault.so}

	doman "${p}"/doc/source/build/man/*
}
