# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs cmake

DATA_HASH="a5b13babe65c1bba7186b41b43d4cbdc20a5c470"
DESCRIPTION="SIMD accelerated C++ JSON library"
HOMEPAGE="
	https://simdjson.org/
	https://github.com/simdjson/simdjson
"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
	test? ( https://github.com/${PN}/${PN}-data/archive/${DATA_HASH}.tar.gz -> ${PN}-data-${DATA_HASH}.tar.gz )
"

LICENSE="Apache-2.0 Boost-1.0 BSD MIT"
SLOT="0/14"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="test tools"

BDEPEND="
	sys-apps/file
	sys-apps/grep
	virtual/pkgconfig
"
DEPEND="
	tools? ( dev-libs/cxxopts:= )
"

REQUIRED_USE="test? ( tools )"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/simdjson-1.0.0-dont-bundle-cxxopts.patch"
	"${FILESDIR}/simdjson-0.9.0-tests.patch"
	"${FILESDIR}/simdjson-1.0.0-dont-fetch-data-tarball.patch"
	"${FILESDIR}/simdjson-1.0.0-install-tools.patch"
	"${FILESDIR}/simdjson-1.0.0-tests.patch"
)

DOCS=(
	AUTHORS
	CONTRIBUTING.md
	CONTRIBUTORS
	HACKING.md
	README.md
)

src_prepare() {
	if use test; then
		mv "${WORKDIR}/${PN}-data-${DATA_HASH}" "${S}/dependencies/${PN}-data" || die
	fi

	sed -e 's:-Werror ::' -i cmake/developer-options.cmake || die
	sed -e '/Werror/ d ; /Werror/ d ' -i tests/ondemand/compilation_failure_tests/CMakeLists.txt || die
	sed -e "s:^c++ :$(tc-getCXX) :" -i singleheader/README.md || die
	mv tools/{,simd}jsonpointer.cpp || die
	cmake_src_prepare
}

src_configure() {
	local -a mycmakeargs=(
		-DSIMDJSON_ENABLE_THREADS=ON
	)
	use test && mycmakeargs+=(
		-DSIMDJSON_TESTS=ON
	)

	if use tools; then
		mycmakeargs+=(
			-DSIMDJSON_DEVELOPER_MODE=ON
			-DSIMDJSON_ALLOW_DOWNLOADS=OFF
			-DSIMDJSON_GOOGLE_BENCHMARKS=OFF
			-DSIMDJSON_COMPETITION=OFF
			-DSIMDJSON_TOOLS=ON
		)
	elif ! use test; then
		mycmakeargs+=(
			-DSIMDJSON_DEVELOPER_MODE=OFF
		)
	fi

	cmake_src_configure
}
