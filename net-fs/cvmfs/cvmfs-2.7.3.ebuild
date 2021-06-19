# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake linux-info bash-completion-r1

DESCRIPTION="HTTP read-only file system for distributing software"
HOMEPAGE="http://cernvm.cern.ch/portal/filesystem"
SRC_URI="https://ecsft.cern.ch/dist/cvmfs/${P}/source.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"

KEYWORDS="amd64 x86"
IUSE="doc server"

CDEPEND="
	acct-group/cvmfs
	acct-user/cvmfs
	app-arch/libarchive
	dev-cpp/gtest
	dev-cpp/sparsehash
	dev-db/sqlite:3=
	dev-libs/leveldb:0=
	dev-libs/openssl:0=
	dev-libs/protobuf:0=
	net-dns/c-ares:0=
	net-libs/pacparser:0=
	net-misc/curl:0[adns]
	sys-apps/attr
	sys-fs/fuse:0=
	sys-fs/fuse:3=
	sys-libs/libcap:0=
	sys-libs/zlib:0=
"

RDEPEND="${CDEPEND}
	app-admin/sudo
	net-fs/autofs
"

DEPEND="${CDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
"

pkg_setup() {
	if use server; then
		CONFIG_CHECK="~OVERLAY_FS"
		ERROR_AUFS_FS="CONFIG_OVERLAY_FS: is required to be set"
		linux-info_pkg_setup
	fi
}

src_prepare() {
	eapply "${FILESDIR}/${PN}-2.7.2-builtins.patch"
	cmake_src_prepare
	# gentoo stuff
	rm bootstrap.sh || die
	sed -i -e "s:/usr/bin/systemctl:/bin/systemctl:g" cvmfs/cvmfs_config || die
	sed -i -e 's/COPYING//' -e "s:cvmfs-\${CernVM-FS_VERSION_STRING}:${PF}:" \
		CMakeLists.txt || die
	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DBUILTIN_EXTERNALS=OFF
		-DBUILD_CVMFS=ON
		-DBUILD_LIBCVMFS=OFF # static library used only for development
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DBUILD_GEOAPI=OFF # only used for stratum 1 servers
		-DBUILD_LIBCVMFS_CACHE=OFF # for exotic cache configs
		-DBUILD_PRELOADER=OFF # special purpose utility for HPCs
		-DBUILD_RECEIVER=OFF # for distributed publishers only
		-DBUILD_SERVER=$(usex server)
		-DINSTALL_BASH_COMPLETION=OFF
		-DINSTALL_MOUNT_SCRIPTS=ON
		-DINSTALL_PUBLIC_KEYS=ON
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	newbashcomp cvmfs/bash_completion/cvmfs.bash_completion cvmfs
	dodoc doc/*.md
}

pkg_config() {
	einfo "Setting up CernVM-FS client"
	cvmfs_config setup
	einfo "Now edit ${EROOT}/etc/cvmfs/default.local"
	einfo "and restart the autofs service"
}
