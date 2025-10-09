# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ header-only library for JSON and JSON-like data formats"
HOMEPAGE="https://danielaparker.github.io/jsoncons/ https://github.com/danielaparker/jsoncons"
SRC_URI="https://github.com/danielaparker/jsoncons/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DOCS=( doc )

# uses modified version of catch.hpp, doesn't work with upstream catch2

src_configure() {
	local mycmakeargs=(
		-DJSONCONS_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
