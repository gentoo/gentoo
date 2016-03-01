# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=WROG
DIST_VERSION=1.20
inherit perl-module

DESCRIPTION="Libraries shared between Net::OpenID::Consumer and Net::OpenID::Server"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Crypt-DH-GMP-0.0.110
	virtual/perl-Encode
	>=dev-perl/HTML-Parser-3.400.0
	>=dev-perl/HTTP-Message-5.814.0
	virtual/perl-MIME-Base64
	virtual/perl-Math-BigInt
	virtual/perl-Time-Local
	dev-perl/XML-Simple
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
