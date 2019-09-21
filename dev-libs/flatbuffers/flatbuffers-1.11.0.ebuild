# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Memory efficient serialization library"
HOMEPAGE="https://google.github.io/flatbuffers/"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs test"

DOCS=( readme.md )

src_configure() {
	local mycmakeargs=(
		-DFLATBUFFERS_BUILD_FLATLIB=$(usex static-libs)
		-DFLATBUFFERS_BUILD_SHAREDLIB=ON
		-DFLATBUFFERS_BUILD_TESTS=$(usex test)
	)

	use elibc_musl && mycmakeargs+=( -DFLATBUFFERS_LOCALE_INDEPENDENT=0 )

	cmake-utils_src_configure
}
