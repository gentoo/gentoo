# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

MYP=${PN}-${PV/_p/-fix}

DESCRIPTION="HTTP read-only file system for distributing software"
HOMEPAGE="http://cernvm.cern.ch/portal/filesystem"
SRC_URI="https://github.com/cvmfs/${PN}/archive/${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="+client debug doc test server"

CDEPEND="
	dev-cpp/gtest
	dev-db/sqlite:3=
	dev-libs/openssl:0
	net-libs/pacparser:0=
	net-misc/curl:0=[adns]
	sys-apps/attr
	sys-libs/zlib:0=
	client? (
		>=dev-cpp/sparsehash-1.12
		dev-libs/leveldb:0=
		sys-fs/fuse:0= )
	server? (
		>=dev-python/geoip-python-1.3.1
		>=dev-cpp/tbb-4.2:0= )"

RDEPEND="${CDEPEND}
	client? ( net-fs/autofs )"
#	server? ( www-servers/apache[ssl] )"

DEPEND="${CDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )"

S="${WORKDIR}/${PN}-${MYP}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-geoip-missing-cmake.patch \
		"${FILESDIR}"/${P}-cares-underlink.patch
	# gentoo stuff
	sed -i -e 's/COPYING//' CMakeLists.txt || die
	rm bootstrap.sh || die
	sed -i \
		-e "s:cvmfs-\${CernVM-FS_VERSION_STRING}:${PF}:" \
		CMakeLists.txt || die

	# hack for bundled vjson
	# vjson not worth unbundling, already upstream obsolete
	# upstream replaced by gason with a new api
	if use server; then
		sed -i \
			-e 's/g++/$(CXX)/g' \
			-e 's/-O2/$(CXXFLAGS)/g' \
			-e 's/ar/$(AR)/' \
			-e 's/ranlib/$(RANLIB)/' \
			externals/vjson/src/Makefile || die
		mkdir -p "${WORKDIR}/${P}_build"/externals/build_vjson
		cp externals/vjson/src/* "${WORKDIR}/${P}_build"/externals/build_vjson/ || die
	fi
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGEOIP_BUILTIN=OFF
		-DGOOGLETEST_BUILTIN=OFF
		-DLEVELDB_BUILTIN=OFF
		-DLIBCURL_BUILTIN=OFF
		-DPACPARSER_BUILTIN=OFF
		-DSPARSEHASH_BUILTIN=OFF
		-DSQLITE3_BUILTIN=OFF
		-DTBB_PRIVATE_LIB=OFF
		-DZLIB_BUILTIN=OFF
		$(cmake-utils_use debug BUILD_SERVER_DEBUG)
		$(cmake-utils_use server BUILD_SERVER)
		$(cmake-utils_use client BUILD_CVMFS)
		$(cmake-utils_use client BUILD_LIBCVMFS)
		$(cmake-utils_use client INSTALL_MOUNT_SCRIPTS)
		$(cmake-utils_use test BUILD_UNITTESTS)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc; then
		cd doc
		doxygen cvmfs.doxy || die
	fi
}

src_install() {
	cmake-utils_src_install
	use doc && dohtml -r doc/html/*
}

pkg_config() {
	if use client; then
		einfo "Setting up CernVM-FS client"
		cvmfs_config setup
		einfo "Now edit ${EROOT%/}/etc/cvmfs/default.local"
		einfo "and restart the autofs service"
	fi
}
