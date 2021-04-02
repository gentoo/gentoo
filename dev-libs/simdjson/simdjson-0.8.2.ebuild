# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="SIMD accelerated C++ JSON library"
HOMEPAGE="
	https://simdjson.org/
	https://github.com/simdjson/simdjson
"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 Boost-1.0"
SLOT="0/4"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="test tools"

BDEPEND="
	sys-apps/file
	sys-apps/findutils
	sys-apps/grep
"
DEPEND="
	tools? ( dev-libs/cxxopts:= )
"

REQUIRED_USE="test? ( tools )"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/simdjson-0.8.0-dont-bundle-cxxopts.patch"
)

DOCS=(
	AUTHORS
	CONTRIBUTING.md
	CONTRIBUTORS
	HACKING.md
	README.md
)

src_prepare() {
	sed -e 's:-Werror ::' -i cmake/simdjson-flags.cmake || die
	cmake_src_prepare
}

src_configure() {
	local -a mycmakeargs=(
		-DSIMDJSON_ENABLE_THREADS=ON
	)

	if use tools; then
		mycmakeargs+=(
			-DSIMDJSON_JUST_LIBRARY=OFF
			-DSIMDJSON_GOOGLE_BENCHMARKS=OFF
			-DSIMDJSON_COMPETITION=OFF
		)
	else
		mycmakeargs+=(
			-DSIMDJSON_JUST_LIBRARY=ON
		)
	fi

	cmake_src_configure
}
