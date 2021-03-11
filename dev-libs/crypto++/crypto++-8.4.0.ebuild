# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="C++ class library of cryptographic schemes"
HOMEPAGE="https://cryptopp.com"
SRC_URI="https://www.cryptopp.com/cryptopp${PV//.}.zip"
S="${WORKDIR}"

LICENSE="Boost-1.0"
SLOT="0/8.4" # subslot is so version (was broken in 8.3.0, check on bumps!)
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ppc ppc64 sparc ~x86 ~x64-macos"
IUSE="+asm static-libs"

BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}/${PN}-8.2.0-musl-ldconfig.patch"
)

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
	default
}

src_compile() {
	emake -f GNUmakefile all shared libcryptopp.pc
}

src_install() {
	default

	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/*.a
}
