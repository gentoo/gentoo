# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Memory efficient serialization library"
HOMEPAGE="
	https://google.github.io/flatbuffers/
	https://github.com/google/flatbuffers/
"
SRC_URI="
	https://github.com/google/flatbuffers/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

DOCS=( readme.md )

src_configure() {
	local mycmakeargs=(
		-DFLATBUFFERS_BUILD_FLATLIB=$(usex static-libs)
		-DFLATBUFFERS_BUILD_SHAREDLIB=ON
		-DFLATBUFFERS_BUILD_TESTS=$(usex test)
		-DFLATBUFFERS_BUILD_BENCHMARKS=OFF
	)

	cmake_src_configure
}
