# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic

DESCRIPTION="Memory efficient serialization library"
HOMEPAGE="https://google.github.io/flatbuffers/"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs test"

src_configure() {
	append-cppflags -std=c++11

	local mycmakeargs=(
		-DFLATBUFFERS_BUILD_FLATLIB=$(usex static-libs)
		-DFLATBUFFERS_BUILD_SHAREDLIB=ON
		-DFLATBUFFERS_BUILD_TESTS=$(usex test)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dobin "${CMAKE_BUILD_DIR}"/flatc
}
