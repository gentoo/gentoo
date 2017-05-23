# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit cmake-utils python-any-r1

DESCRIPTION="Encrypted FUSE filesystem that conceals metadata"
HOMEPAGE="https://www.cryfs.org/"

SLOT=0
IUSE="debug test update-check"

LICENSE="LGPL-3 BSD-2 MIT"
# cryfs - LGPL-3
# scrypt - BSD-2
# spdlog - MIT

if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cryfs/cryfs"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/cryfs/cryfs/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64"
	S="${WORKDIR}"
fi

RDEPEND=">=dev-libs/boost-1.56:=
	>=dev-libs/crypto++-5.6.3:=
	net-misc/curl:=
	>=sys-fs/fuse-2.8.6:=
	dev-libs/openssl:0="
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

src_configure() {
	local mycmakeargs=( "-DBoost_USE_STATIC_LIBS=off"
						"-DCRYFS_UPDATE_CHECKS=$(usex update-check)"
						"-DBUILD_TESTING=$(usex test)" )

	if use debug ; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi

	cmake-utils_src_configure
}

src_test() {
	local TMPDIR="${T}"
	addread /dev/fuse
	addwrite /dev/fuse

	for i in gitversion cpp-utils parallelaccessstore blockstore blobstore fspp cryfs cryfs-cli ; do
		${BUILD_DIR}/test/${i}/${i}-test || eerror "${i}-test failed"
	done

	adddeny /dev/fuse
}
