# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Extremely fast, in memory, JSON and interface library for modern C++"
HOMEPAGE="https://github.com/stephenberry/glaze"
SRC_URI="https://github.com/stephenberry/glaze/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/glaze-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64"
IUSE="examples fuzzing test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-cpp/asio
		>=dev-cpp/eigen-3.4
		dev-cpp/ut2-glaze
	)
"
RDEPEND="${DEPEND}"

# Unbundle test dependencies otherwise they are fetched from github at build time
PATCHES=(
	"${FILESDIR}/${P}-unbundle-test-deps.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_INSTALL_RULES=OFF
		-Dglaze_DEVELOPER_MODE=ON
		-Dglaze_ENABLE_FUZZING=$(usex fuzzing)
		-Dglaze_BUILD_EXAMPLES=$(usex examples)
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}
