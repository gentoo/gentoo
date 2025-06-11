# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Navigation mesh construction toolset for games"
HOMEPAGE="https://github.com/recastnavigation/recastnavigation"
SRC_URI="https://github.com/recastnavigation/recastnavigation/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
#S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="ZLIB"
SLOT="0/1.6.0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/catch:0 )"

PATCHES=(
	"${FILESDIR}/${P}-cmake4.patch"
)

src_prepare() {
	rm -r Tests/Contrib/catch2 || die

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
