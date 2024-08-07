# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake

# TODO: just keep it unbundled...?
MY_BOOST_VERSION="1.77.0"
MY_PV=$(ver_rs 3 '-')
MY_PV="${MY_PV//_pre*}"
MY_PN="Percona-XtraBackup"
MY_P="${PN}-${MY_PV}"
MY_MAJOR_PV=$(ver_cut 1-2)

DESCRIPTION="Hot backup utility for MySQL based servers"
HOMEPAGE="https://www.percona.com/software/mysql-database/percona-xtrabackup"
SRC_URI="https://www.percona.com/downloads/${MY_PN}-${MY_MAJOR_PV}/${MY_PN}-${MY_PV}/source/tarball/${PN}-${MY_PV}.tar.gz
	https://boostorg.jfrog.io/artifactory/main/release/${MY_BOOST_VERSION}/source/boost_$(ver_rs 1- _ ${MY_BOOST_VERSION}).tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	app-arch/lz4:0=
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
	"${FILESDIR}"/${PN}-8.0.26-remove-rpm.patch
	"${FILESDIR}"/${PN}-8.0.30.23-gcc13.patch
	# procps 4 support, released in 8.0.33
	"${FILESDIR}"/6038a7934cbd4e6c01389fdc9b8ffabf8c3e006a.patch
)

S="${WORKDIR}/percona-xtrabackup-${MY_PV}"

src_prepare() {
	cmake_src_prepare

	local bundled_boost_version=$(sed -En '/^SET\(BOOST_PACKAGE_NAME /{s/[^0-9.]//gp}' cmake/boost.cmake)
	if [[ ${MY_BOOST_VERSION//./} != ${bundled_boost_version} ]] ; then
		eerror "Source Boost version: ${bundled_boost_version}"
		eerror "Ebuild Boost version: ${MY_BOOST_VERSION}"
		die "Ebuild needs to fix MY_BOOST_VERSION!"
	fi
}

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
