# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

DESCRIPTION="Navigation mesh construction toolset for games"
HOMEPAGE="https://github.com/recastnavigation/recastnavigation"
MY_COMMIT="c5cbd53024c8a9d8d097a4371215e3342d2fdc87"
SRC_URI="https://github.com/recastnavigation/recastnavigation/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="ZLIB"
SLOT="0/1.5.1"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/catch )"

src_prepare() {
	rm Tests/catch.hpp || die

	cmake_src_prepare
}

src_configure() {
	append-cppflags "-I${ESYSROOT}/usr/include/catch2"

	local mycmakeargs=(
		-DRECASTNAVIGATION_DEMO=OFF
		-DRECASTNAVIGATION_EXAMPLES=OFF
		-DRECASTNAVIGATION_TESTS=$(usex test)
	)

	cmake_src_configure
}
