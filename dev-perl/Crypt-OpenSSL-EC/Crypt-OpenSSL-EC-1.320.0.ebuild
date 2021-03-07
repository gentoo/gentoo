# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MIKEM
DIST_VERSION=1.32
inherit perl-module

DESCRIPTION="Perl extension for OpenSSL EC (Elliptic Curves) library"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test libressl"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Crypt-OpenSSL-Bignum-0.40.0
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
"
DEPEND="
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
