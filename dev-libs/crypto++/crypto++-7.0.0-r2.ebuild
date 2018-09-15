# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="C++ class library of cryptographic schemes"
HOMEPAGE="https://cryptopp.com"
SRC_URI="https://www.cryptopp.com/cryptopp${PV//.}.zip"

LICENSE="Boost-1.0"
SLOT="0/7" # subslot is so version
KEYWORDS="alpha amd64 ~arm arm64 ~hppa ppc ppc64 ~sparc ~x86 ~x64-macos"
IUSE="+asm static-libs"

DEPEND="app-arch/unzip"

S="${WORKDIR}"

pkg_setup() {
	export CXX="$(tc-getCXX)"
	export LIBDIR="${EPREFIX}/usr/$(get_libdir)"
	export PREFIX="${EPREFIX}/usr"
}

src_compile() {

	use asm || append-cxxflags -DCRYPTOPP_DISABLE_ASM

	# ASM isn't Darwin/Mach-O ready, #479554, buildsys doesn't grok CPPFLAGS
	[[ ${CHOST} == *-darwin* ]] && append-cxxflags -DCRYPTOPP_DISABLE_ASM

	emake -f GNUmakefile all shared libcryptopp.pc
}

src_install() {
	default

	use static-libs || rm -f "${ED}${EPREFIX}"/usr/$(get_libdir)/*.a
}
