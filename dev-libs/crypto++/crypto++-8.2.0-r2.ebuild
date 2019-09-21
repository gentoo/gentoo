# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="C++ class library of cryptographic schemes"
HOMEPAGE="https://cryptopp.com"
SRC_URI="https://www.cryptopp.com/cryptopp${PV//.}.zip"

LICENSE="Boost-1.0"
SLOT="0/8" # subslot is so version
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x64-macos"
IUSE="+asm cpu_flags_x86_aes cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_x86_pclmul cpu_flags_x86_sha cpu_flags_x86_sse2 cpu_flags_x86_sse4_2 cpu_flags_x86_ssse3 static-libs"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
)

config_add() {
	sed -i -e "/Important Settings/a#define $1 1" config.h || die
}

pkg_setup() {
	export CXX="$(tc-getCXX)"
	export LIBDIR="${EPREFIX}/usr/$(get_libdir)"
	export PREFIX="${EPREFIX}/usr"
}

src_prepare() {
	default

	use asm || config_add CRYPTOPP_DISABLE_ASM
	use cpu_flags_x86_aes || config_add CRYPTOPP_DISABLE_AESNI
	use cpu_flags_x86_avx || config_add CRYPTOPP_DISABLE_AVX
	use cpu_flags_x86_avx2 || config_add CRYPTOPP_DISABLE_AVX2
	use cpu_flags_x86_pclmul || config_add CRYPTOPP_DISABLE_CLMUL
	use cpu_flags_x86_sha || config_add CRYPTOPP_DISABLE_SHANI
	use cpu_flags_x86_sse2 || config_add CRYPTOPP_DISABLE_SSE2
	use cpu_flags_x86_sse4_2 || config_add CRYPTOPP_DISABLE_SSE4
	use cpu_flags_x86_ssse3 || config_add CRYPTOPP_DISABLE_SSSE3

	# ASM isn't Darwin/Mach-O ready, #479554, buildsys doesn't grok CPPFLAGS
	[[ ${CHOST} == *-darwin* ]] && config_add CRYPTOPP_DISABLE_ASM
}

src_compile() {
	emake -f GNUmakefile all shared libcryptopp.pc
}

src_install() {
	default

	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/*.a
}
