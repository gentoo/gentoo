# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MIKEM
DIST_VERSION=1.32
inherit perl-module

DESCRIPTION="Perl extension for OpenSSL EC (Elliptic Curves) library"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test "
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Crypt-OpenSSL-Bignum-0.40.0
	dev-libs/openssl:0=
"
DEPEND="
	dev-libs/openssl:0
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
