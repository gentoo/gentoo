# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools eutils

MyPN=secp256k1
DESCRIPTION="Optimized C library for EC operations on curve secp256k1"
HOMEPAGE="https://github.com/bitcoin-core/${MyPN}"
COMMITHASH="7a78f60598a6aeb635ef227ead50fb44a209c363"
SRC_URI="https://github.com/bitcoin-core/${MyPN}/archive/${COMMITHASH}.tar.gz -> ${PN}-v${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+asm ecdh endomorphism experimental gmp java +recovery test test-openssl"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	asm? ( || ( amd64 arm ) arm? ( experimental ) )
	ecdh? ( experimental )
	java? ( ecdh )
	test-openssl? ( test )
"
RDEPEND="
	gmp? ( dev-libs/gmp:0= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	java? ( virtual/jdk )
	test-openssl? ( dev-libs/openssl:0 )
"

S="${WORKDIR}/${MyPN}-${COMMITHASH}"

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
		$(use_enable java jni) \
		$(use_enable test tests) \
		$(use_enable test-openssl openssl-tests) \
		$(use_enable ecdh module-ecdh) \
		$(use_enable endomorphism)  \
		--with-asm=$asm_opt \
		--with-bignum=$(usex gmp gmp no) \
		$(use_enable recovery module-recovery) \
		--disable-static
}

src_install() {
	dodoc README.md
	emake DESTDIR="${D}" install
	find "${D}" -name '*.la' -delete || die
}
