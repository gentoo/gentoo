# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Efficient evaluation of integrals over ab initio effective core potentials"
HOMEPAGE="https://github.com/robashaw/libecpint"
SRC_URI="https://github.com/robashaw/libecpint/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/pugixml"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"

src_prepare() {
	cmake_src_prepare

	find . -name CMakeLists.txt -exec \
		sed -i -e 's/CXX_STANDARD 11/CXX_STANDARD 14/g' {} \; || die
}

src_configure() {
	local mycmakeargs=(
		-DLIBECPINT_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
