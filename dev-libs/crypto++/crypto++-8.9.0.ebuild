# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/crypto++.asc
inherit flag-o-matic toolchain-funcs verify-sig

DESCRIPTION="C++ class library of cryptographic schemes"
HOMEPAGE="https://cryptopp.com"
SRC_URI="
	https://www.cryptopp.com/cryptopp${PV//.}.zip
	verify-sig? ( https://cryptopp.com/cryptopp${PV//.}.zip.sig )
"

S="${WORKDIR}"

LICENSE="Boost-1.0"
# ABI notes:
# - Bumped to 8.5 in 8.5.0 out of caution
# subslot is so version (was broken in 8.3.0, check on bumps!)
# Seems to be broken in 8.6 again too
#
# - See https://cryptopp.com/#news, but releases usually say
# "recompile of programs required". Even if it doesn't,
# verify with abidiff!
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv sparc x86 ~x64-macos"
IUSE="+asm static-libs"

BDEPEND="
	app-arch/unzip
	verify-sig? ( sec-keys/openpgp-keys-crypto++ )
"

config_uncomment() {
	sed -i -e "s://\s*\(#define\s*$1\):\1:" config.h || die
}

src_prepare() {
	default

	use asm || config_uncomment CRYPTOPP_DISABLE_ASM

	# ASM isn't Darwin/Mach-O ready, #479554, buildsys doesn't grok CPPFLAGS
	[[ ${CHOST} == *-darwin* ]] && config_uncomment CRYPTOPP_DISABLE_ASM
}

src_configure() {
	export CXX="$(tc-getCXX)"
	export LIBDIR="${EPREFIX}/usr/$(get_libdir)"
	export PREFIX="${EPREFIX}/usr"
	tc-export AR RANLIB

	# Long history of correctness bugs:
	# https://github.com/weidai11/cryptopp/issues/1134
	# https://github.com/weidai11/cryptopp/issues/1141
	# https://github.com/weidai11/cryptopp/pull/1147
	append-flags -fno-strict-aliasing
	filter-lto

	default
}

src_compile() {
	emake -f GNUmakefile LDCONF=true all shared libcryptopp.pc
}

src_install() {
	emake DESTDIR="${D}" LDCONF=true install

	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/*.a
}
