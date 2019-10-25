# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MIKEM
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="OpenSSL ECDSA (Elliptic Curve Digital Signature Algorithm) Perl extension"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl"

RDEPEND="
	>=dev-perl/Crypt-OpenSSL-EC-0.50.0
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PATCHES=(
	"${FILESDIR}/${P}-0002-Port-to-OpenSSL-1.1.0.patch"
)
