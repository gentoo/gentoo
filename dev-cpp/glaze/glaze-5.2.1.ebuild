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
KEYWORDS="~amd64"
IUSE="doc examples fuzzing test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-cpp/ut2-glaze
		dev-cpp/asio
		>=dev-cpp/eigen-3.4
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
		-Dglaze_ENABLE_FUZZING=$(usex fuzzing ON OFF)
		-Dglaze_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DBUILD_TESTING=$(usex test ON OFF)
	)

	cmake_src_configure
}
