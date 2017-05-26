# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit cmake-utils python-any-r1

DESCRIPTION="Encrypted FUSE filesystem that conceals metadata"
HOMEPAGE="https://www.cryfs.org/"

SLOT=0
IUSE="test update-check"

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
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}"
fi

RDEPEND=">=dev-libs/boost-1.56:=
	>=dev-libs/crypto++-5.6.3:=
	net-misc/curl:=
	>=sys-fs/fuse-2.8.6:=
	dev-libs/openssl:0="
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

src_prepare() {
	# remove tests that require internet access to comply with Gentoo policy
	sed -i -e '/CurlHttpClientTest.cpp/d' -e '/FakeHttpClientTest.cpp/d' test/cpp-utils/CMakeLists.txt || die

	# remove non-applicable warning
	sed -i -e '/WARNING! This is a debug build. Performance might be slow./d' src/cryfs-cli/Cli.cpp || die

	cmake-utils_src_prepare
}

src_configure() {
	# upstream restricts installing files to Release configuration
	# (CMAKE_BUILD_TYPE does not affect anything else)
	local CMAKE_BUILD_TYPE=Release
	local mycmakeargs=(
		"-DBoost_USE_STATIC_LIBS=off"
		"-DCRYFS_UPDATE_CHECKS=$(usex update-check)"
		"-DBUILD_TESTING=$(usex test)"
	)

	cmake-utils_src_configure
}

src_test() {
	local TMPDIR="${T}"
	addread /dev/fuse
	addwrite /dev/fuse
	local tests_failed=()

	for i in gitversion cpp-utils parallelaccessstore blockstore blobstore fspp cryfs cryfs-cli ; do
		"${BUILD_DIR}"/test/${i}/${i}-test || tests_failed+=( "${i}" )
	done

	adddeny /dev/fuse

	if [[ -n ${tests_failed[@]} ]] ; then
		eerror "The following tests failed:"
		eerror "$tests_failed[@]"
		die "At least one test failed"
	fi
}
