# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Memory efficient serialization library"
HOMEPAGE="https://google.github.io/flatbuffers/"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
# From 1.2.0->2.0.0, incremented SONAME, although the interface didn't actually change.
# (Apparently to adopt semver.)
SLOT="0/2"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"
IUSE="static-libs test"

# out-of-source build broken, bug #842060
RESTRICT="test !test? ( test )"

DOCS=( readme.md )

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.6-locales-detection-fixup.patch
)

src_configure() {
	local mycmakeargs=(
		-DFLATBUFFERS_BUILD_FLATLIB=$(usex static-libs)
		-DFLATBUFFERS_BUILD_SHAREDLIB=ON
		-DFLATBUFFERS_BUILD_TESTS=$(usex test)
		-DFLATBUFFERS_BUILD_BENCHMARKS=OFF
	)

	cmake_src_configure
}
