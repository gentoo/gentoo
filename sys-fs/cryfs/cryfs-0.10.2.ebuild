# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7}} )
inherit cmake-utils flag-o-matic linux-info python-any-r1

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cryfs/cryfs"
else
	SRC_URI="https://github.com/cryfs/cryfs/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm arm64 x86"
	S="${WORKDIR}"
fi

DESCRIPTION="Encrypted FUSE filesystem that conceals metadata"
HOMEPAGE="https://www.cryfs.org/"

LICENSE="LGPL-3 MIT"
SLOT="0"
IUSE="custom-optimization debug libressl test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/boost-1.65.1:=
	>=dev-libs/crypto++-8.2.0:=
	net-misc/curl:=
	>=sys-fs/fuse-2.8.6:0
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	test? ( dev-cpp/gtest )
"

PATCHES=(
	# TODO upstream:
	"${FILESDIR}/${P}-unbundle-libs.patch"
	"${FILESDIR}/${P}-install-targets.patch"
)

pkg_setup() {
	local CONFIG_CHECK="~FUSE_FS"
	local WARNING_FUSE_FS="CONFIG_FUSE_FS is required for cryfs support."

	check_extra_config
}

src_prepare() {
	cmake-utils_src_prepare

	# don't install compressed manpage
	cmake_comment_add_subdirectory doc

	# remove tests that require internet access to comply with Gentoo policy
	sed -e "/CurlHttpClientTest.cpp/d" -e "/FakeHttpClientTest.cpp/d" \
		-i test/cpp-utils/CMakeLists.txt || die

	# /dev/fuse access denied
	sed -e "/CliTest_IntegrityCheck/d" \
		-i test/cryfs-cli/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DBoost_USE_STATIC_LIBS=OFF
		-DCRYFS_UPDATE_CHECKS=OFF
		-DBUILD_SHARED_LIBS=OFF
		-DUSE_SYSTEM_LIBS=ON
		-DBUILD_TESTING=$(usex test)
	)
	use custom-optimization || append-flags -O3

	cmake-utils_src_configure
}

src_test() {
	local TMPDIR="${T}"
	local tests_failed=()

	# fspp fuse tests hang, bug # 699044
	for i in gitversion cpp-utils parallelaccessstore blockstore blobstore cryfs cryfs-cli ; do
		"${BUILD_DIR}"/test/${i}/${i}-test || tests_failed+=( "${i}" )
	done

	if [[ -n ${tests_failed[@]} ]] ; then
		eerror "The following tests failed:"
		eerror "${tests_failed[@]}"
		die "At least one test failed"
	fi
}

src_install() {
	cmake-utils_src_install
	doman doc/man/cryfs.1
}
