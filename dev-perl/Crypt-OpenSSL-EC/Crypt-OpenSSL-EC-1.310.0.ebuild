# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MIKEM
DIST_VERSION=1.31
inherit perl-module

DESCRIPTION="Perl extension for OpenSSL EC (Elliptic Curves) library"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test libressl"

RDEPEND="
	>=dev-perl/Crypt-OpenSSL-Bignum-0.40.0
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
