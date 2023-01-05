# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_PN=${PN##lib}

DESCRIPTION="Optimized C library for EC operations on curve secp256k1"
HOMEPAGE="https://github.com/bitcoin-core/secp256k1"
if [[ ${PV} == *_p* ]] ; then
	MY_COMMIT="3967d96bf184519eb98b766af665b4d4b072563e"
	SRC_URI="https://github.com/bitcoin-core/${MyPN}/archive/${COMMITHASH}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${MY_PN}-${MY_COMMIT}
else
	SRC_URI="https://github.com/bitcoin-core/secp256k1/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${MY_PN}-${PV}
fi

LICENSE="MIT"
SLOT="0/1"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+asm ecdh experimental +extrakeys lowmem precompute-ecmult +schnorr +recovery test valgrind"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	?? ( lowmem precompute-ecmult )
	asm? (
		|| ( amd64 arm )
	)
	schnorr? ( extrakeys )
"

BDEPEND="
	virtual/pkgconfig
	test? ( dev-libs/openssl )
	valgrind? ( dev-util/valgrind )
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

	local myeconfargs=(
		--disable-benchmark
		$(use_enable experimental)
		$(use_enable test tests)
		$(use_enable test exhaustive-tests)
		$(use_enable ecdh module-ecdh)
		$(use_enable extrakeys module-extrakeys)
		--with-asm=${asm_opt}
		$(use_enable recovery module-recovery)
		$(use_enable schnorr module-schnorrsig)
		$(usev lowmem '--with-ecmult-window=2 --with-ecmult-gen-precision=2')
		$(usev precompute-ecmult '--with-ecmult-window=24 --with-ecmult-gen-precision=8')
		$(use_with valgrind)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
