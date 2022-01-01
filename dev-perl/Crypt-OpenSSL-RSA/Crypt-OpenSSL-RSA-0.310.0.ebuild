# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=TODDR
DIST_VERSION=0.31
inherit perl-module

DESCRIPTION="RSA encoding and decoding using the OpenSSL libraries"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Crypt-OpenSSL-Bignum
	dev-perl/Crypt-OpenSSL-Random
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )
"
DEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )
"
BDEPEND="${RDEPEND}
	>=dev-perl/Crypt-OpenSSL-Guess-0.110.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test
	)
"
PERL_RM_FILES=(
	t/z_kwalitee.t
	t/z_perl_minimum_version.t
	t/z_meta.t
	t/z_pod-coverage.t
	t/z_pod.t
)
mydoc="rfc*.txt"

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
