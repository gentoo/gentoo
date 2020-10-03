# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Efficient evaluation of integrals over ab initio effective core potentials"
HOMEPAGE="https://github.com/robashaw/libecpint"
SRC_URI="https://github.com/robashaw/libecpint/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="
	dev-libs/pugixml
	test? ( dev-cpp/gtest )"

src_configure() {
	mycmakeargs=(
		-DLIBECPINT_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
