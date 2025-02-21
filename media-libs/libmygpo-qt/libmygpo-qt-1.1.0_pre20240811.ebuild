# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=4d1f48291791c64f029e69138e3bc7fb6a851610
inherit cmake

DESCRIPTION="Qt/C++ library wrapping the gpodder.net webservice"
HOMEPAGE="https://github.com/gpodder/libmygpo-qt"
SRC_URI="https://github.com/gpodder/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-qt/qtbase:6[network]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

# Pending: https://github.com/gpodder/libmygpo-qt/pull/23
PATCHES=( "${FILESDIR}/${P}-qt6.patch" )

src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_QT6=ON
		-DMYGPO_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# bug: 653312
		JsonCreatorTest-test
	)
	cmake_src_test
}
