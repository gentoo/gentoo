# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MyPN=secp256k1
DESCRIPTION="Optimized C library for EC operations on curve secp256k1"
HOMEPAGE="https://github.com/bitcoin-core/secp256k1"
COMMITHASH="3967d96bf184519eb98b766af665b4d4b072563e"
SRC_URI="https://github.com/bitcoin-core/${MyPN}/archive/${COMMITHASH}.tar.gz -> ${PN}-v${PV}.tgz"
S="${WORKDIR}/${MyPN}-${COMMITHASH}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="asm ecdh +experimental +extrakeys gmp lowmem +recovery +schnorr test test-openssl valgrind"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	asm? ( || ( amd64 arm ) arm? ( experimental ) )
	extrakeys? ( experimental )
	schnorr? ( experimental extrakeys )
	test-openssl? ( test )
"
RDEPEND="
	gmp? ( dev-libs/gmp:0= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test-openssl? ( dev-libs/openssl:0 )
	valgrind? ( dev-debug/valgrind )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local asm_opt
	if use asm; then
		if use arm; then
			asm_opt=arm
		else
			asm_opt=auto
		fi
	else
		asm_opt=no
	fi
	econf \
		--disable-benchmark \
		$(use_enable experimental) \
		$(use_enable test tests) \
		$(use_enable test exhaustive-tests) \
		$(use_enable test-openssl openssl-tests) \
		$(use_enable ecdh module-ecdh) \
		$(use_enable extrakeys module-extrakeys) \
		--with-asm=${asm_opt} \
		--with-bignum=$(usex gmp gmp no) \
		$(use_enable recovery module-recovery) \
		$(use_enable schnorr module-schnorrsig) \
		$(usex lowmem '--with-ecmult-window=4 --with-ecmult-gen-precision=2' '') \
		$(use_with valgrind) \
		--disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
