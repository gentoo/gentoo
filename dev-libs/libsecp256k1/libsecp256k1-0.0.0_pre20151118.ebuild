# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

MyPN=secp256k1
DESCRIPTION="Optimized C library for EC operations on curve secp256k1"
HOMEPAGE="https://github.com/bitcoin/${MyPN}"
COMMITHASH="6c527eceee7f5105c33c98dfae24ffeffd71f7cf"
SRC_URI="https://github.com/bitcoin/${MyPN}/archive/${COMMITHASH}.tar.gz -> ${MyPN}-v${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="asm doc ecdh endomorphism experimental gmp libressl +recovery schnorr test"

REQUIRED_USE="
	asm? ( amd64 )
	ecdh? ( experimental )
	schnorr? ( experimental )
"
RDEPEND="
	gmp? ( dev-libs/gmp:0 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
"

S="${WORKDIR}/${MyPN}-${COMMITHASH}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--disable-benchmark \
		$(use_enable test tests) \
		$(use_enable ecdh module-ecdh) \
		$(use_enable endomorphism)  \
		--with-asm=$(usex asm auto no) \
		--with-bignum=$(usex gmp gmp no) \
		$(use_enable recovery module-recovery) \
		$(use_enable schnorr module-schnorr) \
		--disable-static
}

src_install() {
	if use doc; then
		dodoc README.md
	fi

	emake DESTDIR="${D}" install
	prune_libtool_files
}
