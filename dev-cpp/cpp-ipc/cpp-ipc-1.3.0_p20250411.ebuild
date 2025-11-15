# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="C++ IPC Library"
HOMEPAGE="https://github.com/mutouyun/cpp-ipc/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mutouyun/cpp-ipc.git"
else
	COMMIT="a0c7725a1441d18bc768d748a93e512a0fa7ab52"
	SRC_URI="
		https://github.com/mutouyun/cpp-ipc/archive/${COMMIT}.tar.gz
			-> ${PN}-${COMMIT}.tar.gz
	"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-cpp/gtest
	)
"

PATCHES=(
	"${FILESDIR}"/cpp-ipc-1.3.0_p20250411-system-gtest.patch
	"${FILESDIR}"/cpp-ipc-1.3.0_p20250411-install-correctly.patch
)

src_prepare() {
	default

	# Remove the vendored gtest to avoid mixing it with system gtest
	# Do it before cmake_prepare to avoid cmake-3.5 QA
	rm -rf 3rdparty/gtest || die

	cmake_prepare
}

src_configure() {
	filter-lto

	local mycmakeargs=(
		-DLIBIPC_BUILD_TESTS=$(usex test)
		-DLIBIPC_BUILD_SHARED_LIBS=ON
	)
	cmake_src_configure
}

src_test() {
	ebegin "Testing test-ipc"
	"${BUILD_DIR}"/bin/test-ipc
	eend ${?} || die "test-ipc failed"
}
