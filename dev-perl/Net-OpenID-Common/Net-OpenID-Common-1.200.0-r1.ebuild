# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=WROG
DIST_VERSION=1.20
inherit perl-module

DESCRIPTION="Libraries shared between Net::OpenID::Consumer and Net::OpenID::Server"

SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-perl/Crypt-DH-GMP-0.0.110
	virtual/perl-Encode
	>=dev-perl/HTML-Parser-3.400.0
	>=dev-perl/HTTP-Message-5.814.0
	virtual/perl-MIME-Base64
	virtual/perl-Math-BigInt
	virtual/perl-Time-Local
	dev-perl/XML-Simple
	!<dev-perl/Net-OpenID-Consumer-1.30.99
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
