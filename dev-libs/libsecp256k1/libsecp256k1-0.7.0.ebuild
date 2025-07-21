# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake edo toolchain-funcs

MyPN=secp256k1
DESCRIPTION="Optimized C library for EC operations on curve secp256k1"
HOMEPAGE="https://github.com/bitcoin-core/secp256k1"
SRC_URI="https://github.com/bitcoin-core/secp256k1/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MyPN}-${PV}"

LICENSE="MIT"
SLOT="0/6"  # subslot is "$((_LIB_VERSION_CURRENT-_LIB_VERSION_AGE))" from configure.ac
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="asm +ecdh +ellswift experimental +extrakeys lowmem musig +recovery +schnorr test test-full valgrind"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	asm? ( || ( amd64 arm ) arm? ( experimental ) )
	musig? ( schnorr )
	schnorr? ( extrakeys )
	test-full? ( test )
"
BDEPEND="
	>=dev-build/cmake-3.22
	virtual/pkgconfig
	valgrind? ( dev-debug/valgrind )
"

PATCHES=(
)

DOCS=(
	README.md
	doc/safegcd_implementation.md
)

src_prepare() {
	cmake_src_prepare

	# Generation of the precomputed tables has not been migrated to CMake.
	rm -f src/precomputed_ecmult.c src/precomputed_ecmult_gen.c || die
	local precompute_defines=(
		# These magic numbers come from configure.ac.
		-DECMULT_WINDOW_SIZE=$(usex lowmem 4 15)
		-DCOMB_BLOCKS=$(usex lowmem 2 43)
		-DCOMB_TEETH=$(usex lowmem 5 6)
		-DVERIFY
	)
	tc-env_build emake -C src precompute_ecmult{,_gen} CPPFLAGS+="${precompute_defines[*]}"
	edo src/precompute_ecmult
	edo src/precompute_ecmult_gen
}

src_configure() {
	local mycmakeargs=(
		-DSECP256K1_BUILD_BENCHMARK=OFF
		-DSECP256K1_EXPERIMENTAL=$(usex experimental)
		-DSECP256K1_BUILD_TESTS=$(usex test)
		-DSECP256K1_BUILD_EXHAUSTIVE_TESTS=$(usex test-full)
		-DSECP256K1_ENABLE_MODULE_ECDH=$(usex ecdh)
		-DSECP256K1_ENABLE_MODULE_ELLSWIFT=$(usex ellswift)
		-DSECP256K1_ENABLE_MODULE_EXTRAKEYS=$(usex extrakeys)
		-DSECP256K1_ENABLE_MODULE_MUSIG=$(usex musig)
		-DSECP256K1_ENABLE_MODULE_RECOVERY=$(usex recovery)
		-DSECP256K1_ENABLE_MODULE_SCHNORRSIG=$(usex schnorr)
		-DSECP256K1_ASM=$(usex asm "$(usex arm arm32 AUTO)" OFF)
		-DSECP256K1_VALGRIND=$(usex valgrind ON OFF)
	)
	use lowmem && mycmakeargs+=(
		-DSECP256K1_ECMULT_WINDOW_SIZE=4
		-DSECP256K1_ECMULT_GEN_KB=2
	)
	cmake_src_configure
}

src_install() {
	use ellswift && DOCS+=( doc/ellswift.md )
	use musig && DOCS+=( doc/musig.md )

	cmake_src_install
}
