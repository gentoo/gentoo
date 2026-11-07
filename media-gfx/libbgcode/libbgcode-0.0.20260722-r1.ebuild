# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# normally we use the main branch, but the fixes in lm_fixes branch are not merged to the main
# branch yet even though pinned by prusaslicer 2.9.7 so for the purpose of this ebuild we apply
# the patches from the branch through the complete tarball instead of picking them separately
LIBBGCODE_COMMIT=167c8e19a26e74de42bbb3622480ee04a9420394

DESCRIPTION="Prusa Block & Binary G-code reader / writer / converter"
HOMEPAGE="https://github.com/prusa3d/libbgcode"
SRC_URI="https://github.com/prusa3d/libbgcode/archive/${LIBBGCODE_COMMIT}.tar.gz -> ${PF}.tar.gz"

S="${WORKDIR}/${PN}-${LIBBGCODE_COMMIT}"
LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/heatshrink-0.4.1
	>=virtual/zlib-1.0:=
"
DEPEND="${RDEPEND}
	dev-libs/boost
	test? ( >=dev-cpp/catch-3.8 )
"

PATCHES=(
	"${FILESDIR}/libbgcode-0.0.20260722-r1-meatpack-tests.patch"
)

src_configure() {
	local mycmakeargs=(
		-DLibBGCode_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
