# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

MyPN=secp256k1
DESCRIPTION="Optimized C library for EC operations on curve secp256k1"
HOMEPAGE="https://github.com/bitcoin/${MyPN}"
COMMITHASH="22f60a62801a8a49ecd049e7a563f69a41affd8d"
SRC_URI="https://github.com/bitcoin/${MyPN}/archive/${COMMITHASH}.tar.gz -> ${MyPN}-v${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="asm doc endomorphism gmp libressl test"

REQUIRED_USE="
	asm? ( amd64 )
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
		$(use_enable endomorphism)  \
		--with-asm=$(usex asm auto no) \
		--with-bignum=$(usex gmp gmp no) \
		--disable-static
}

src_install() {
	if use doc; then
		dodoc README.md
	fi

	emake DESTDIR="${D}" install
	prune_libtool_files
}
