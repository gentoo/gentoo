# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

CommitId=4fe0e1e183925bf8cfa6aae24237e724a96479b8
DESCRIPTION="Portable and efficient thread pool implementation"
HOMEPAGE="https://github.com/Maratyszcza/pthreadpool"
SRC_URI="https://github.com/Maratyszcza/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}"/${PN}-${CommitId}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"

DEPEND="dev-libs/FXdiv"
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-2022.05.09-gentoo.patch
)

src_prepare() {
	cmake_src_prepare

	# >=dev-cpp/gtest-1.13.0 requires C++14 standard or later
	sed -i -e 's/CXX_STANDARD 11/CXX_STANDARD 14/g' \
		CMakeLists.txt || die "sed failed"
}

src_configure() {
	local mycmakeargs=(
		-DPTHREADPOOL_BUILD_BENCHMARKS=OFF
		-DPTHREADPOOL_BUILD_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}
