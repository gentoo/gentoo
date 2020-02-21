# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils linux-info bash-completion-r1

MYP=${PN}-${PV/_p/-fix}

DESCRIPTION="HTTP read-only file system for distributing software"
HOMEPAGE="http://cernvm.cern.ch/portal/filesystem"
SRC_URI="https://github.com/cvmfs/${PN}/archive/${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="aufs bash-completion debug doc preload server test test-programs"
RESTRICT="!test? ( test )"

CDEPEND="
	dev-cpp/gtest
	>=dev-cpp/sparsehash-1.12
	dev-db/sqlite:3=
	dev-libs/leveldb:0=
	dev-libs/openssl:0
	net-libs/pacparser:0=
	net-misc/curl:0[adns]
	sys-apps/attr
	sys-fs/fuse:0=
	sys-libs/libcap:0=
	sys-libs/zlib:0=
	preload? ( >=dev-cpp/tbb-4.4:0=[debug?] )
	server? (
		>=dev-cpp/tbb-4.4:0=[debug?]
		dev-python/geoip-python
	)
"

RDEPEND="${CDEPEND}
	app-admin/sudo
	net-fs/autofs
	server? (
		aufs? ( sys-kernel/aufs-sources )
		www-servers/apache
	)
"

DEPEND="${CDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
	test? (
		dev-python/geoip-python
		>=dev-cpp/tbb-4.4:0=
		|| ( sys-devel/gdb dev-util/lldb )
	)
"

REQUIRED_USE="test-programs? ( server )"

S="${WORKDIR}/${PN}-${MYP}"

pkg_setup() {
	if use server; then
		if use aufs; then
			CONFIG_CHECK="~AUFS_FS"
			ERROR_AUFS_FS="CONFIG_AUFS_FS: is required to be set with the aufs flag"
		else
			CONFIG_CHECK="~OVERLAY_FS"
			ERROR_AUFS_FS="CONFIG_OVERLAY_FS: is required to be set"
		fi
		linux-info_pkg_setup
	fi
}

src_prepare() {
	cmake-utils_src_prepare
	# gentoo stuff
	sed -i -e 's/COPYING//' CMakeLists.txt || die
	rm bootstrap.sh || die
	sed -e "s:cvmfs-\${CernVM-FS_VERSION_STRING}:${PF}:" \
		-i CMakeLists.txt || die

	# hack for bundled packages
	# not worth unbundling upstreams are flaky/dead
	local pkg
	for pkg in vjson sha2 sha3; do
		# respect toolchain variables
		sed -e 's/g++/$(CXX)/g' \
			-e 's/gcc/$(CC)/g' \
			-e 's/CFLAGS/MYCFLAGS/g' \
			-e 's/-O2/$(CFLAGS)/g' \
			-e 's/-O2/$(CXXFLAGS)/g' \
			-e 's/ar/$(AR)/' \
			-e 's/ranlib/$(RANLIB)/' \
			-i externals/${pkg}/src/Makefile || die
		mkdir -p "${WORKDIR}/${P}_build"/externals/build_${pkg}
		cp -r externals/${pkg}/src/* \
		   "${WORKDIR}/${P}_build"/externals/build_${pkg}/ || die
	done
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
		-DBUILD_CVMFS=ON
		-DBUILD_LIBCVMFS=ON
		-DINSTALL_MOUNT_SCRIPTS=ON
		-DINSTALL_PUBLIC_KEYS=ON
		-DINSTALL_BASH_COMPLETION=OFF
		-DBUILD_DOCUMENTATION="$(usex doc)"
		-DBUILD_PRELOADER="$(usex preload)"
		-DBUILD_SERVER="$(usex server)"
	)
	if use test || use test-programs; then
		mycmakeargs+=( -DBUILD_UNITTESTS=ON )
	fi
	use test-programs && mycmakeargs+=( -DINSTALL_UNITTESTS=ON )
	if use debug; then
		mycmakeargs+=(
			$(cmake-utils_use server BUILD_SERVER_DEBUG)
			$(cmake-utils_use test BUILD_UNITTESTS_DEBUG)
		)
	fi
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_compile doc
}

src_install() {
	cmake-utils_src_install
	use bash-completion && \
		newbashcomp cvmfs/bash_completion/cvmfs.bash_completion cvmfs
	dodoc doc/*.md
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r "${BUILD_DIR}"/html
		docompress -x /usr/share/doc/${PF}/html
	fi
}

pkg_config() {
	einfo "Setting up CernVM-FS client"
	cvmfs_config setup
	einfo "Now edit ${EROOT%/}/etc/cvmfs/default.local"
	einfo "and restart the autofs service"
}
