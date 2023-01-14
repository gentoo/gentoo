# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Navigation mesh construction toolset for games"
HOMEPAGE="https://github.com/recastnavigation/recastnavigation"
MY_COMMIT="405cc095ab3a2df976a298421974a2af83843baf"
SRC_URI="https://github.com/recastnavigation/recastnavigation/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="ZLIB"
SLOT="0/1.5.1"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/catch:0 )"

PATCHES=(
	"${FILESDIR}/${P}-catch.patch"
)

src_prepare() {
	rm Tests/Contrib/Catch/* || die
	echo "#include <catch2/catch_all.hpp>" > Tests/Contrib/Catch/catch_amalgamated.hpp || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DRECASTNAVIGATION_DEMO=OFF
		-DRECASTNAVIGATION_EXAMPLES=OFF
		-DRECASTNAVIGATION_TESTS=$(usex test)
	)

	cmake_src_configure
}
