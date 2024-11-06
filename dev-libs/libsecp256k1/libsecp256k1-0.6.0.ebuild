# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MyPN=secp256k1
DESCRIPTION="Optimized C library for EC operations on curve secp256k1"
HOMEPAGE="https://github.com/bitcoin-core/secp256k1"
SRC_URI="https://github.com/bitcoin-core/secp256k1/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MyPN}-${PV}"

LICENSE="MIT"
SLOT="0/5"  # subslot is "$((_LIB_VERSION_CURRENT-_LIB_VERSION_AGE))" from configure.ac
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="asm +ecdh +ellswift experimental +extrakeys lowmem musig +recovery +schnorr test valgrind"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	asm? ( || ( amd64 arm ) arm? ( experimental ) )
	musig? ( schnorr )
	schnorr? ( extrakeys )
"
BDEPEND="
	dev-build/autoconf-archive
	virtual/pkgconfig
	valgrind? ( dev-debug/valgrind )
"

PATCHES=(
	"${FILESDIR}/0.4.0-fix-cross-compile.patch"
)

DOCS=(
	README.md
	doc/safegcd_implementation.md
)

src_prepare() {
	default
	eautoreconf

	# Generate during build
	rm -f src/precomputed_ecmult.c src/precomputed_ecmult_gen.c || die
}

src_configure() {
	local myeconfargs=(
		--disable-benchmark
		$(use_enable experimental)
		$(use_enable test tests)
		$(use_enable test exhaustive-tests)
		$(use_enable {,module-}ecdh)
		$(use_enable {,module-}ellswift)
		$(use_enable {,module-}extrakeys)
		$(use_enable {,module-}musig)
		$(use_enable {,module-}recovery)
		$(use_enable schnorr module-schnorrsig)
		$(use_with asm asm "$(usex arm arm32 auto)")
		$(usev lowmem '--with-ecmult-window=4 --with-ecmult-gen-kb=2')
		$(use_with valgrind)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	use ellswift && DOCS+=( doc/ellswift.md )
	use musig && DOCS+=( doc/musig.md )

	default
	find "${ED}" -name '*.la' -delete || die
}
