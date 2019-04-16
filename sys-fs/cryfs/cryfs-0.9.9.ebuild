# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CMAKE_MAKEFILE_GENERATOR=emake
PYTHON_COMPAT=( python{2_7,3_{5,6}} )

inherit cmake-utils python-any-r1 flag-o-matic

DESCRIPTION="Encrypted FUSE filesystem that conceals metadata"
HOMEPAGE="https://www.cryfs.org/"

SLOT=0
IUSE="custom-optimization libressl test update-check"

LICENSE="LGPL-3 BSD-2 MIT"
# cryfs - LGPL-3
# scrypt - BSD-2
# spdlog - MIT

if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cryfs/cryfs"
else
	SRC_URI="https://github.com/cryfs/cryfs/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 x86"
	S="${WORKDIR}"
fi

RDEPEND=">=dev-libs/boost-1.56:=
	>=dev-libs/crypto++-5.6.3:=
	net-misc/curl:=
	>=sys-fs/fuse-2.8.6:=
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

src_prepare() {
	cmake-utils_src_prepare

	# remove tests that require internet access to comply with Gentoo policy
	sed -i -e '/CurlHttpClientTest.cpp/d' -e '/FakeHttpClientTest.cpp/d' test/cpp-utils/CMakeLists.txt || die

	# remove non-applicable warning
	sed -i -e '/WARNING! This is a debug build. Performance might be slow./d' src/cryfs-cli/Cli.cpp || die
}

src_configure() {
	# upstream restricts installing files to Release configuration
	# (CMAKE_BUILD_TYPE does not affect anything else)
	local CMAKE_BUILD_TYPE
	local -a mycmakeargs
	CMAKE_BUILD_TYPE=Release
	mycmakeargs=(
		"-DBoost_USE_STATIC_LIBS=off"
		"-DCRYFS_UPDATE_CHECKS=$(usex update-check)"
		"-DBUILD_TESTING=$(usex test)"
	)
	use custom-optimization || append-flags -O3

	cmake-utils_src_configure
}

src_test() {
	local TMPDIR
	TMPDIR="${T}"
	addread /dev/fuse
	addwrite /dev/fuse
	local -a tests_failed
	tests_failed=()

	for i in gitversion cpp-utils parallelaccessstore blockstore blobstore fspp cryfs cryfs-cli ; do
		"${BUILD_DIR}"/test/${i}/${i}-test || tests_failed+=( "${i}" )
	done

	adddeny /dev/fuse

	if [[ -n ${tests_failed[@]} ]] ; then
		eerror "The following tests failed:"
		eerror "${tests_failed[@]}"
		die "At least one test failed"
	fi
}

src_install() {
	# work around upstream issue with cmake not creating install target
	# in Makefile if we enable BUILD_TESTING
	dobin "${BUILD_DIR}/src/cryfs-cli/cryfs"
	gzip -cd "${BUILD_DIR}/doc/cryfs.1.gz" > "${T}/cryfs.1" || die
	doman "${T}/cryfs.1"
	einstalldocs
}
