# Copyright 2020-2024 Gentoo Authors
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
SLOT="0/22"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="+all-impls test tools"

BDEPEND="
	sys-apps/file
	sys-apps/grep
	virtual/pkgconfig
"
DEPEND="
	tools? ( <dev-libs/cxxopts-3.1:= )
"

REQUIRED_USE="test? ( tools )"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/simdjson-1.0.0-dont-bundle-cxxopts.patch"
	"${FILESDIR}/simdjson-0.9.0-tests.patch"
	"${FILESDIR}/simdjson-1.0.0-install-tools.patch"
	"${FILESDIR}/simdjson-3.1.7-tests.patch"
	"${FILESDIR}/simdjson-3.7.1-data-optional.patch"
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
		mkdir "${S}/dependencies/.cache" || die
		mv "${WORKDIR}/${PN}-data-${DATA_HASH}" "${S}/dependencies/.cache/${PN}-data" || die
	fi

	sed -e 's:-Werror ::' -i cmake/developer-options.cmake || die
	sed -e '/Werror/ d ; /Werror/ d ' -i tests/ondemand/compilation_failure_tests/CMakeLists.txt || die
	sed -e "s:^c++ :$(tc-getCXX) :" -i singleheader/README.md || die
	mv tools/{,simd}jsonpointer.cpp || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSIMDJSON_ENABLE_THREADS:BOOL=ON
	)
	use test && mycmakeargs+=(
		-DSIMDJSON_TESTS:BOOL=ON
	)

	if use tools; then
		mycmakeargs+=(
			-DSIMDJSON_DEVELOPER_MODE:BOOL=ON
			-DSIMDJSON_ALLOW_DOWNLOADS:BOOL=OFF
			-DSIMDJSON_GOOGLE_BENCHMARKS:BOOL=OFF
			-DSIMDJSON_COMPETITION:BOOL=OFF
			-DSIMDJSON_TOOLS:BOOL=ON
		)
	elif ! use test; then
		mycmakeargs+=(
			-DSIMDJSON_DEVELOPER_MODELBOOL=OFF
		)
	fi

	if use all-impls; then
		local -a impls=("fallback")
		if use amd64 || use x86; then
			impls+=("westmere" "haswell" "icelake")
		elif use arm64; then
			impls+=("arm64")
		elif use ppc64; then
			impls+=("ppc64")
		fi

		mycmakeargs+=(
			-DSIMDJSON_IMPLEMENTATION:STRING=$(printf '%s;' "${impls[@]}")
		)
	fi

	cmake_src_configure
}
