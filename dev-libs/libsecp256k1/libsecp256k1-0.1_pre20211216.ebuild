# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs

MyPN=secp256k1
DESCRIPTION="Optimized C library for EC operations on curve secp256k1"
HOMEPAGE="https://github.com/bitcoin-core/secp256k1"
COMMITHASH="0559fc6e41b65af6e52c32eb9b1286494412a162"
SRC_URI="https://github.com/bitcoin-core/${MyPN}/archive/${COMMITHASH}.tar.gz -> ${PN}-v${PV}.tgz"

LICENSE="MIT"
SLOT="0/20210628"  # subslot is date of last ABI change
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+asm ecdh +experimental +extrakeys lowmem precompute-ecmult +schnorr +recovery test valgrind"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	asm? ( || ( amd64 arm ) arm? ( experimental ) )
	extrakeys? ( experimental )
	?? ( lowmem precompute-ecmult )
	schnorr? ( experimental extrakeys )
"
RDEPEND="
	!=dev-util/bitcoin-tx-0.21* !=dev-util/bitcoin-tx-21.2-r0
	!=dev-util/bitcoin-tx-22.0-r0 !=dev-util/bitcoin-tx-22.0-r1[-recent-libsecp256k1(+)]
	!=dev-util/bitcoin-tx-22.0-r2[-recent-libsecp256k1(+)]
	!=net-p2p/bitcoind-0.21* !=net-p2p/bitcoind-21.2-r0
	!=net-p2p/bitcoind-22.0-r0 !=net-p2p/bitcoind-22.0-r1[-recent-libsecp256k1(+)]
	!=net-p2p/bitcoin-qt-0.21* !=net-p2p/bitcoin-qt-21.2-r0
	!=net-p2p/bitcoin-qt-22.0-r0 !=net-p2p/bitcoin-qt-22.0-r1[-recent-libsecp256k1(+)]
	!=net-libs/libbitcoinconsensus-0.21* !=net-libs/libbitcoinconsensus-21.2-r0
	!=net-libs/libbitcoinconsensus-22.0-r0
	!net-p2p/core-lightning[-recent-libsecp256k1(-)]
"
DEPEND="${RDEPEND}
	valgrind? ( dev-util/valgrind )
"
BDEPEND="
	virtual/pkgconfig
"

LIBSECP256K1_CROSS_TOOLS=( gen_ecmult_gen_static_prec_table gen_ecmult_static_pre_g )

is_crosscompile() {
	[[ ${CHOST} != ${CBUILD:-${CHOST}} ]]
}

S="${WORKDIR}/${MyPN}-${COMMITHASH}"

src_prepare() {
	default
	eautoreconf

	# Generate during build
	rm -f src/ecmult_gen_static_prec_table.h src/ecmult_static_pre_g.h || die
}

src_configure() {
	local myconf=(
		--disable-benchmark
		$(use_enable experimental)
		$(use_enable test tests)
		$(use_enable test exhaustive-tests)
		$(use_enable {,module-}ecdh)
		$(use_enable {,module-}extrakeys)
		$(use_enable {,module-}recovery)
		$(use_enable schnorr module-schnorrsig)
		$(usex lowmem '--with-ecmult-window=2 --with-ecmult-gen-precision=2' '')
		$(usex precompute-ecmult '--with-ecmult-window=24 --with-ecmult-gen-precision=8' '')
		--disable-static
	)

	if is_crosscompile; then
		einfo "Building native code generation tools"
		(
			unset AR AS CC CPP CXX LD NM OBJCOPY OBJDUMP RANLIB RC STRIP CHOST
			strip-unsupported-flags
			econf "${myconf[@]}" --without-valgrind
			emake CC="$(tc-getCC)" "${LIBSECP256K1_CROSS_TOOLS[@]}"
		)
		einfo "Resuming with crosscompile target"
	fi

	myconf+=(
		$(use_with valgrind)
	)
	if use asm; then
		if use arm; then
			myconf+=( --with-asm=arm )
		else
			myconf+=( --with-asm=auto )
		fi
	else
		myconf+=( --with-asm=no )
	fi

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
